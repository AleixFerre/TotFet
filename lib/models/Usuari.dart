import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totfet/services/storage.dart';

class Usuari {
  final String uid;
  String nom;
  String email;
  String token;
  String bio;
  bool isAdmin;
  Timestamp dataCreacio;
  bool teFoto;
  Map<String, dynamic> notificacions;

  Usuari({
    @required this.uid,
    this.nom,
    this.email,
    this.isAdmin,
    this.token,
    this.bio,
    this.dataCreacio,
    this.teFoto,
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
      teFoto: data['teFoto'],
    );
  }

  Map<String, dynamic> toDBMap() {
    return {
      "nom": nom.trim(),
      "isAdmin": isAdmin,
      "token": token,
      "dataCreacio": dataCreacio ?? DateTime.now(),
      "bio": bio,
      "teFoto": teFoto,
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
      teFoto: false,
      notificacions: {
        "compres": true,
        "tasques": true,
        "tancar_informes": true,
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
    return getAvatar(nom, uid, true, teFoto);
  }

  Future<String> get avatarFile async {
    try {
      if (!teFoto) return null;
      String link = await StorageService().getImageFromUser(uid);
      return link;
    } catch (e) {
      return null;
    }
  }

  static CircleAvatar getAvatar(
      String nom, String id, bool esGran, bool teFoto) {
    double mida = esGran ? 50 : 20;

    return CircleAvatar(
      backgroundColor: Colors.blue,
      child: teFoto
          ? FutureBuilder<String>(
              future: StorageService().getImageFromUser(id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    inicials(nom),
                    style: TextStyle(fontSize: mida),
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

                return SizedBox(
                  height: mida,
                  width: mida,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
              },
            )
          : Text(
              inicials(nom),
              style: TextStyle(fontSize: mida),
            ),
      radius: mida,
    );
  }
}
