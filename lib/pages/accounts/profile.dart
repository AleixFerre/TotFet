import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/models/Llista.dart';
import 'package:compres/pages/accounts/edit_profile.dart';
import 'package:compres/pages/llistes/crear_llista.dart';
import 'package:compres/pages/llistes/unirse_llista.dart';
import 'package:flutter/material.dart';

import 'package:compres/services/auth.dart';
import 'package:compres/services/database.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/shared/some_error_page.dart';
import 'package:compres/models/Usuari.dart';

class Perfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final Stream<DocumentSnapshot> futureSnapshot =
        DatabaseService(uid: _auth.userId).getUserData();

    return StreamBuilder(
      stream: futureSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return SomeErrorPage(error: snapshot.error);
        }

        if (snapshot.hasData) {
          DocumentSnapshot doc = snapshot.data;
          Usuari usuari = Usuari.fromDB(
            _auth.userId,
            _auth.userEmail,
            doc.data(),
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
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 150,
                        color: Colors.blue,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  usuari.nom.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              usuari.isAdmin
                                  ? Icon(
                                      Icons.verified,
                                      color: Colors.indigo[300],
                                    )
                                  : Container(),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            usuari.email,
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  Divider(),
                  Center(
                    child: Text(
                      "Les meves llistes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        elevation: 3,
                        onPressed: () async {
                          Llista result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CrearLlista(),
                            ),
                          );
                          if (result != null) {
                            await DatabaseService().addList(result);
                            print("Llista creada correctament!");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.library_add,
                                size: 50,
                              ),
                              Text("Crear"),
                            ],
                          ),
                        ),
                      ),
                      RaisedButton(
                        elevation: 3,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UnirseLlista(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.group_add,
                                size: 50,
                              ),
                              Text("Unir-me"),
                            ],
                          ),
                        ),
                      ),
                      RaisedButton(
                        elevation: 3,
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.settings,
                                size: 50,
                              ),
                              Text("Administrar"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 40,
                  ),
                  /* Per ara no s'implementa el tema de les vistes
                  Center(
                    child: Text(
                      "Les meves compres",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        elevation: 3,
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.add_circle,
                                size: 50,
                              ),
                              Text("Creades"),
                            ],
                          ),
                        ),
                      ),
                      RaisedButton(
                        elevation: 3,
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: 50,
                              ),
                              Text("Comprades"),
                            ],
                          ),
                        ),
                      ),
                      RaisedButton(
                        elevation: 3,
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.notifications,
                                size: 50,
                              ),
                              Text("Assignades"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),*/
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    "UID: " + _auth.userId,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Si encara no hi ha dades
        return Scaffold(
          body: Loading("Carregant les dades del perfil..."),
        );
      },
    );
  }
}
