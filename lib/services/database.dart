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
    return await compresCollection
        .add(
          result,
        )
        .catchError(
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

  Future<void> sortirUsuarideLlista(String llistaID) async {
    QuerySnapshot info = await llistesUsuarisCollection
        .where("llista", isEqualTo: llistaID)
        .where("usuari", isEqualTo: AuthService().userId)
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
      print(querySnapshot.docs.length);
      return querySnapshot.docs.length == 0;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<DocumentSnapshot> getUserData() {
    return usersCollection.doc(uid).snapshots();
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

  Future<DocumentSnapshot> getNom() async {
    DocumentSnapshot details = await usersCollection.doc(id).get();
    return details;
  }
}
