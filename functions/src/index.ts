import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

async function enviarNotificacioCompra(snapshot: functions.firestore.QueryDocumentSnapshot) {
  if (!snapshot.exists) {
    console.log("No devices connected.");
    return;
  }

  const tokens = [];

  const compra = snapshot;

  if (compra?.idAssignat === null) {
    console.log("No s'ha assignat a ningu!");
    return;
  }

  const usuari = await db.collection("usuaris").doc(compra.idAssignat).get();

  if (usuari?.notificacions["compres"] === false) {
    console.log("Té configurat que no s'enviin notificacions de compres!");
    return;
  }

  tokens.push(usuari?.token);

  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: "T'han assignat una compra!",
      body: `Has de comprar ${compra.quantitat} de ${compra.nom}.`,
    },
    data: {
      clickAction: "FLUTTER_NOTIFICATION_CLICK",
      view: "detalls_compra",
      compraID: snapshot.id,
    },
  };

  try {
    await fcm.sendToDevice(tokens, payload);
  } catch (e: any) {
    console.log(e.toString());
  }
}

async function enviarNotificacioTasca(snapshot: functions.firestore.QueryDocumentSnapshot) {
  if (!snapshot.exists) {
    console.log("No devices connected.");
    return;
  }

  const tokens = [];

  const tasca = snapshot;

  if (tasca?.idAssignat === null) {
    console.log("No s'ha assignat a ningu!");
    return;
  }

  const usuari = await db.collection("usuaris").doc(tasca.idAssignat).get();

  if (usuari?.notificacions["tasques"] === false) {
    console.log("Té configurat que no s'enviin notificacions de tasques!");
    return;
  }

  tokens.push(usuari?.token);

  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: "T'han assignat una tasca!",
      body: `Has de ${tasca.nom}.`,
    },
    data: {
      clickAction: "FLUTTER_NOTIFICATION_CLICK",
      view: "detalls_tasca",
      compraID: snapshot.id,
    },
  };

  try {
    await fcm.sendToDevice(tokens, payload);
  } catch (e: any) {
    console.log(e.toString());
  }
}

async function enviarNotificacioInforme(snapshot: functions.firestore.QueryDocumentSnapshot) {
  if (!snapshot.exists) {
    console.log("No devices connected.");
    return;
  }

  const informe = snapshot;

  const admins = await db.collection("usuaris").where("isAdmin", "==", true).get();

  if (admins.docs.length === 0) {
    console.log("No hi ha cap admin per enviar la notificació!");
    return;
  }

  const tokens = admins.docs.map((e: { token: any }) => e.token);

  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: "Hi ha un nou informe!",
      body: `${informe.titol}`,
    },
    data: {
      clickAction: "FLUTTER_NOTIFICATION_CLICK",
      view: "detalls_informe",
      informeID: snapshot.id,
    },
  };

  try {
    await fcm.sendToDevice(tokens, payload);
  } catch (e: any) {
    console.log(e.toString());
  }
}

async function enviarNotificacioInformeTancat(snapshot: functions.firestore.QueryDocumentSnapshot) {
  if (!snapshot.exists) {
    console.log("No devices connected.");
    return;
  }

  const informe = snapshot;

  const admins = await db.collection("usuaris").where("isAdmin", "==", true).get();

  if (admins.docs.length === 0) {
    console.log("No hi ha cap admin per enviar la notificació!");
    return;
  }

  const usuari = await db.collection("usuaris").doc(informe.autor).get();

  if (usuari?.notificacions["tancar_informes"] === false) {
    console.log("Té configurat que no s'enviin notificacions de tancar informes!");
    return;
  }

  const tokens = admins.docs.map((e: { token: any }) => e.token);

  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: "S'ha tancat el teu informe!",
      body: `${informe.titol}`,
    },
    data: {
      clickAction: "FLUTTER_NOTIFICATION_CLICK",
      view: "detalls_informe",
      informeID: snapshot.id,
    },
  };

  try {
    await fcm.sendToDevice(tokens, payload);
  } catch (e: any) {
    console.log(e.toString());
  }
}

// Retorna si hi ha hagut un canvi al camp idAssignat
function comprovarCanviAssignat(snapshot: functions.Change<functions.firestore.QueryDocumentSnapshot>): boolean {
  return snapshot.before?.idAssignat !== snapshot.after?.idAssignat;
}

//? -------- COMPRES --------
export const alCrearCompra = functions.firestore.document("compres/{idAssignat}").onCreate(async (snapshot: any) => await enviarNotificacioCompra(snapshot));

export const alActualitzarCompra = functions.firestore.document("compres/{idAssignat}").onUpdate(async (snapshot: { after: any }) => {
  if (comprovarCanviAssignat(snapshot)) await enviarNotificacioCompra(snapshot.after);
});

//? -------- TASQUES --------
export const alCrearTasca = functions.firestore.document("tasques/{idAssignat}").onCreate(async (snapshot: any) => await enviarNotificacioTasca(snapshot));

export const alActualitzarTasca = functions.firestore.document("tasques/{idAssignat}").onUpdate(async (snapshot: { after: any }) => {
  if (comprovarCanviAssignat(snapshot)) await enviarNotificacioTasca(snapshot.after);
});

//? -------- INFORMES --------
export const alCrearInforme = functions.firestore.document("reports/{idInforme}").onCreate(async (snapshot: any) => await enviarNotificacioInforme(snapshot));

export const alTancarInforme = functions.firestore
  .document("reports/{idInforme}")
  .onUpdate(async (snapshot: { after: any }) => await enviarNotificacioInformeTancat(snapshot.after));
