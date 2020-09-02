import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/models/Usuari.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(Usuari usuari) async {
    return await usersCollection.doc(uid).set({
      "nom": usuari.nom,
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    return await usersCollection.doc(uid).get();
  }
}
