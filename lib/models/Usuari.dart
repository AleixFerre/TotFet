import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:totfet/services/storage.dart';

class Usuari {
  final String uid;
  String nom;
  String email;
  String token;
  String bio;
  bool isAdmin;
  Timestamp dataCreacio;
  Map<String, dynamic> notificacions;

  Usuari({
    @required this.uid,
    this.nom,
    this.email,
    this.isAdmin,
    this.token,
    this.bio,
    this.dataCreacio,
    this.notificacions,
  });

  static Usuari fromDB(String id, String _email, Map<String, dynamic> data) {
    return Usuari(
      uid: id,
      email: _email,
      nom: data['nom'],
      isAdmin: data['isAdmin'],
      token: data['token'],
      bio: data['bio'],
      dataCreacio: data['dataCreacio'],
      notificacions: data['notificacions'],
    );
  }

  Map<String, dynamic> toDBMap() {
    return {
      "nom": nom.trim(),
      "isAdmin": isAdmin,
      "token": token,
      "dataCreacio": dataCreacio ?? DateTime.now(),
      "bio": bio,
      "notificacions": notificacions,
    };
  }

  static List<String> fromRefDB(QuerySnapshot referencies) {
    return referencies.docs.map((e) => e.data()['usuari'].toString()).toList();
  }

  static Usuari perDefecte(String _uid) {
    return Usuari(
      uid: _uid,
      nom: "Nou membre",
      token: "",
      isAdmin: false,
      notificacions: {
        "compres": true,
        "tasques": true,
      },
    );
  }

  static String inicials(String s) {
    List<String> paraules = s.split(" ");
    String fi = paraules[0].substring(0, 1).toUpperCase();
    if (paraules.length > 1) {
      fi += paraules[1].substring(0, 1).toUpperCase();
    }
    return fi;
  }

  CircleAvatar get avatar {
    return getAvatar(nom, uid, true);
  }

  Future<String> get avatarFile async {
    try {
      String link = await StorageService().getImageFromUser(uid);
      return link;
    } catch (e) {
      return null;
    }
  }

  static CircleAvatar getAvatar(String nom, String id, bool esGran) {
    return CircleAvatar(
      backgroundColor: Colors.blue,
      child: FutureBuilder<String>(
        future: StorageService().getImageFromUser(id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              inicials(nom),
              style: TextStyle(fontSize: esGran ? 50 : 20),
            );
          }

          if (snapshot.hasData) {
            // MOSTRAR LA IMATGE
            String src = snapshot.data;
            return ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(src),
            );
          }

          double mida = esGran ? 50 : 20;
          return SizedBox(
            height: mida,
            width: mida,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        },
      ),
      radius: esGran ? 50 : 20,
    );
  }
}
