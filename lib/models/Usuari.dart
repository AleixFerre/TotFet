import 'package:flutter/material.dart';

class Usuari {
  final String uid;
  String nom;
  String email;
  String urlImg;
  bool isAdmin;

  Usuari({@required this.uid, this.nom, this.email, this.urlImg, this.isAdmin});

  static Usuari fromDB(String id, String _email, Map<String, dynamic> data) {
    return Usuari(
      uid: id,
      email: _email,
      nom: data['nom'],
      urlImg: data['urlImg'],
      isAdmin: data['isAdmin'],
    );
  }

  Map<String, dynamic> toDBMap() {
    return {
      "nom": nom,
      "isAdmin": isAdmin,
      // Expandible...
    };
  }

  static Usuari perDefecte(String _uid) {
    return Usuari(
      uid: _uid,
      nom: "Nou membre",
      isAdmin: false,
    );
  }
}
