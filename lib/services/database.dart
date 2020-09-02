import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/models/Usuari.dart';

class DatabaseService {
  final String uid;
  final String id;
  DatabaseService({this.uid, this.id});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference compresCollection =
      FirebaseFirestore.instance.collection('productes');

  Future<void> updateUserData(Usuari usuari) async {
    return await usersCollection.doc(uid).set({
      "nom": usuari.nom,
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    return await usersCollection.doc(uid).get();
  }

  Future<DocumentSnapshot> getCompresData() async {
    return await compresCollection.doc(id).get();
  }
}
