import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/pages/accounts/edit_profile.dart';
import 'package:flutter/material.dart';

import 'package:compres/services/auth.dart';
import 'package:compres/services/database.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/shared/some_error_page.dart';
import 'package:compres/models/Usuari.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final Future<DocumentSnapshot> futureSnapshot =
        DatabaseService(uid: _auth.userId).getUserData();

    return FutureBuilder(
      future: futureSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return SomeErrorPage(error: snapshot.error);
        }
        if (snapshot.hasData) {
          DocumentSnapshot doc = snapshot.data;
          Usuari usuari = Usuari(
            uid: _auth.userId,
            nom: doc.data()['nom'],
            // Es poden posar més atributs aqui si es cal
          );
          return Scaffold(
            appBar: AppBar(
              title: Text("Perfil"),
              actions: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    Usuari resposta = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPerfil(usuari: usuari),
                      ),
                    );
                    if (resposta != null) {
                      // Instantaniament al fer rebuild s'actualitza la Query
                      await DatabaseService(uid: usuari.uid)
                          .updateUserData(resposta);
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User ID: " + _auth.userId,
                    style: TextStyle(fontSize: 20),
                  ),
                  Divider(),
                  Text(
                    "Nom: " + usuari.nom,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          );
        }

        // Si encara no hi ha dades
        return Loading("Carregant les dades del perfil...");
      },
    );
  }
}
