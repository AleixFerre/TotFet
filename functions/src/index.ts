import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


export const sendToDevice = functions.firestore
  .document('compres/{idAssignat}')
  .onCreate(async snapshot => {

    if (!snapshot.exists) {
      console.log("No devices connected.");
      return;
    }

    const tokens = [];

    const compra = snapshot.data();

    if (compra.idAssignat === null) {
      console.log("No s'ha assignat a ningu!");
      return;
    }

    const usuari = await db.collection('usuaris').doc(compra.idAssignat).get();

    tokens.push(usuari.data()?.token);

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: "T'han assignat una compra!",
        body: `Has de comprar ${compra.quantitat} de ${compra.nom}.`,
      },
      data: {
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
        view: "detalls_compra",
        compraID: snapshot.id,
      }
    }

    try {
      await fcm.sendToDevice(tokens, payload);
    } catch (e) {
      console.log(e.toString());
    }
  });
