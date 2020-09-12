import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/models/Llista.dart';
import 'package:compres/models/Usuari.dart';
import 'package:compres/services/auth.dart';

class DatabaseService {
  final String uid;
  final String id;
  DatabaseService({this.uid, this.id});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('usuaris');
  final CollectionReference compresCollection =
      FirebaseFirestore.instance.collection('compres');
  final CollectionReference tasquesCollection =
      FirebaseFirestore.instance.collection('tasques');
  final CollectionReference llistesCollection =
      FirebaseFirestore.instance.collection('llistes');
  final CollectionReference llistesUsuarisCollection =
      FirebaseFirestore.instance.collection('llistes_usuaris');

  Future<void> updateUserData(Usuari usuari) async {
    return await usersCollection.doc(uid).set(usuari.toDBMap());
  }

  Future<void> updateLlista(Llista llista) async {
    return await llistesCollection.doc(llista.id).set(llista.toDBMap());
  }

  Future<void> addCompra(Map<String, dynamic> result) async {
    return await compresCollection.add(result).catchError(
          (error) => print("Error a l'afegir producte: $error"),
        );
  }

  Future<void> addList(Llista llista) async {
    // Afegim la llista a la taula LLISTES
    DocumentReference llistaCreada =
        await llistesCollection.add(llista.toDBMap());
    // Afegim la relacio USUARI - LLISTA a la taula de relacions
    return await addUsuariLlista(llistaCreada.id);
  }

  Future<void> addUsuariLlista(String id) async {
    return await llistesUsuarisCollection.add({
      "llista": id,
      "usuari": AuthService().userId,
    });
  }

  Future<void> editarCompra(String compraKey, Map resposta) async {
    return await compresCollection.doc(compraKey).update(resposta);
  }

  Future<void> comprarCompra(String compraKey) async {
    compresCollection.doc(compraKey).update({
      "comprat": true,
      "idComprador": AuthService().userId,
      "dataCompra": Timestamp.now(),
    });
  }

  Future<void> esborrarCompra(String compraKey) async {
    return await compresCollection.doc(compraKey).delete();
  }

  Future<void> setHost(String llistaID, String uid) async {
    await llistesCollection.doc(llistaID).update({
      "idCreador": uid,
    });
  }

  Future<void> actualitzarToken(String uid, String token) async {
    await usersCollection.doc(uid).update({
      "token": token,
    });
  }

  Future<void> esborrarLlista(String llistaID) async {
    // S'ESBORREN TOTS ELS USUARIS DE LLISTES-USUARIS VINCULATS A AQUESTA LLISTA
    QuerySnapshot usuaris = await llistesUsuarisCollection
        .where("llista", isEqualTo: llistaID)
        .get();

    for (QueryDocumentSnapshot usuari in usuaris.docs) {
      llistesUsuarisCollection.doc(usuari.id).delete();
    }

    // S'ESBORREN TOTES LES COMPRES AMB AQUESTA LLISTA ASSIGNADA
    QuerySnapshot compres =
        await compresCollection.where("idLlista", isEqualTo: llistaID).get();

    for (QueryDocumentSnapshot compra in compres.docs) {
      compresCollection.doc(compra.id).delete();
    }

    // S'esborra la llista en si de la taula Llistes
    await llistesCollection.doc(llistaID).delete();
  }

  Future<void> sortirUsuarideLlista(String llistaID, String uid) async {
    // Mirar totes les compres i tasques a les que està assignat
    // Només d'aquella llista
    // I posar el camp idAssignat a null

    QuerySnapshot compres = await compresCollection
        .where("idAssignat", isEqualTo: uid)
        .where("idLlista", isEqualTo: llistaID)
        .get();

    for (QueryDocumentSnapshot compra in compres.docs) {
      Map<String, dynamic> actualitzada = compra.data();
      actualitzada['idAssignat'] = null;
      await compresCollection.doc(compra.id).update(actualitzada);
    }

    // El mateix per les tasques
    // Només d'aquella llista
    QuerySnapshot tasques = await tasquesCollection
        .where("idAssignat", isEqualTo: uid)
        .where("idLlista", isEqualTo: llistaID)
        .get();

    for (QueryDocumentSnapshot tasca in tasques.docs) {
      Map<String, dynamic> actualitzada = tasca.data();
      actualitzada['idAssignat'] = null;
      await tasquesCollection.doc(tasca.id).update(actualitzada);
    }

    // Esborrar la relacio Llistes - Usuaris
    QuerySnapshot info = await llistesUsuarisCollection
        .where("llista", isEqualTo: llistaID)
        .where("usuari", isEqualTo: uid)
        .get();
    return llistesUsuarisCollection.doc(info.docs[0].id).delete();
  }

  Future<bool> existeixLlista(String id) async {
    try {
      DocumentSnapshot document = await llistesCollection.doc(id).get();
      return document.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> pucEntrarLlista(String id) async {
    try {
      // Miro si ja existeix aquesta entrada
      QuerySnapshot querySnapshot = await llistesUsuarisCollection
          .where("usuari", isEqualTo: AuthService().userId)
          .where("llista", isEqualTo: id)
          .get();
      return querySnapshot.docs.length == 0;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<DocumentSnapshot> getUserData() {
    return usersCollection.doc(uid).snapshots();
  }

  Future<QuerySnapshot> getUsuarisLlista(String id) async {
    QuerySnapshot refUsuaris =
        await llistesUsuarisCollection.where("llista", isEqualTo: id).get();
    return await getUsersData(Usuari.fromRefDB(refUsuaris));
  }

  Future<QuerySnapshot> getUsersData(List<String> idUsuaris) {
    return usersCollection
        .where(FieldPath.documentId, whereIn: idUsuaris)
        .get();
  }

  Stream<QuerySnapshot> getLlistesData() {
    return llistesCollection.snapshots();
  }

  Stream<QuerySnapshot> getLlistesInData(List<String> ids) {
    return llistesCollection
        .where(FieldPath.documentId, whereIn: ids)
        .snapshots();
  }

  Stream<QuerySnapshot> getLlistesUsuarisData(String uid) {
    return llistesUsuarisCollection.where("usuari", isEqualTo: uid).snapshots();
  }

  Stream<DocumentSnapshot> getCompresData() {
    return compresCollection.doc(id).snapshots();
  }

  Stream<QuerySnapshot> getLlistesUsuarisActualData() {
    return llistesUsuarisCollection
        .where("usuari", isEqualTo: AuthService().userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getInfoLlistesIn(List<String> llistaDeReferencies) {
    return llistesCollection
        .where(FieldPath.documentId, whereIn: llistaDeReferencies)
        .snapshots();
  }

  Stream<QuerySnapshot> getCompresInfoWhere(String idLlista, bool comprat) {
    return compresCollection
        .where("idLlista", isEqualTo: idLlista)
        .where("comprat", isEqualTo: comprat)
        .snapshots();
  }
}
