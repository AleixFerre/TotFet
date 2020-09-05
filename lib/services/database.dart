import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/models/Llista.dart';
import 'package:compres/models/Usuari.dart';

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

  Future<void> addList(Llista llista) async {
    // Afegim la llista a la taula LLISTES
    DocumentReference llistaCreada =
        await llistesCollection.add(llista.toDBMap());
    // Afegim la relacio USUARI - LLISTA a la taula de relacions
    return await llistesUsuarisCollection.add({
      "llista": llistaCreada.id,
      "usuari": llista.idCreador,
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    return await usersCollection.doc(uid).get();
  }

  Stream<DocumentSnapshot> getCompresData() {
    return compresCollection.doc(id).snapshots();
  }

  Future<DocumentSnapshot> getNom() async {
    DocumentSnapshot details = await usersCollection.doc(id).get();
    return details;
  }
}
