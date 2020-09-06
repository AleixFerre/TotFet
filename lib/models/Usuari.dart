import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      "nom": nom.trim(),
      "isAdmin": isAdmin,
      // Expandible...
    };
  }

  static List<String> fromRefDB(QuerySnapshot referencies) {
    return referencies.docs
        .map(
          (e) => e.data()['usuari'].toString(),
        )
        .toList();
  }

  static Usuari perDefecte(String _uid) {
    return Usuari(
      uid: _uid,
      nom: "Nou membre",
      isAdmin: false,
    );
  }

  String _inicials(String s) {
    List<String> paraules = s.split(" ");
    String fi = paraules[0].substring(0, 1).toUpperCase();
    if (paraules.length > 1) {
      fi += paraules[1].substring(0, 1).toUpperCase();
    }
    return fi;
  }

  CircleAvatar get avatar {
    return CircleAvatar(
      backgroundColor: Colors.blue,
      child: Text(
        _inicials(this.nom),
        style: TextStyle(fontSize: 60),
      ),
      radius: 60,
    );
  }
}
