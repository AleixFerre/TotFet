import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/models/Llista.dart';
import 'package:compres/services/auth.dart';
import 'package:compres/services/database.dart';
import 'package:compres/shared/llista_buida.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/shared/some_error_page.dart';
import 'package:flutter/material.dart';

class AdminLlistes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Administrador de llistes"),
        ),
      ),
      body: StreamBuilder(
          stream: DatabaseService().getLlistesUsuarisData(AuthService().userId),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return SomeErrorPage(error: snapshot.error);
            }

            if (snapshot.hasData) {
              if (snapshot.data.docs.length == 0) {
                return LlistaBuida();
              }
              // Si hi ha dades i no estan buides, mostrem la llista
              return montarLlista(snapshot.data.docs);
            }

            return Loading("Carregant les llistes (1/2)...");
          }),
    );
  }

  StreamBuilder<QuerySnapshot> montarLlista(
      List<QueryDocumentSnapshot> idLlistes) {
    List<String> llistaIDs = idLlistes
        .map(
          (e) => e.data()['llista'].toString(),
        )
        .toList();

    return StreamBuilder(
      stream: DatabaseService().getLlistesInData(llistaIDs),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return SomeErrorPage(error: snapshot.error);
        }

        if (snapshot.hasData) {
          PopupMenuButton<int> construirDesplegable(bool isOwner) {
            List<Map<String, dynamic>> opcions = [
              {
                "nom": "Esborrar",
                "icon": Icon(Icons.delete),
                "function": () {
                  return print("Esborrar");
                },
              },
              {
                "nom": "Editar",
                "icon": Icon(Icons.edit),
                "function": () {
                  return print("Editar");
                },
              },
              {
                "nom": "Sortir",
                "icon": Icon(Icons.exit_to_app),
                "function": () {
                  return print("Sortir");
                },
              },
            ];

            if (!isOwner) {
              opcions.removeAt(1);
              opcions.removeAt(0);
            }

            return PopupMenuButton<int>(
              tooltip: "Opcions de la llista",
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) {
                return opcions
                    .map(
                      (Map<String, dynamic> opcio) => PopupMenuItem(
                        value: opcions.indexOf(opcio),
                        child: Row(
                          children: [
                            opcio['icon'],
                            SizedBox(width: 5),
                            Text(opcio['nom']),
                          ],
                        ),
                      ),
                    )
                    .toList();
              },
              onSelected: (int index) {
                return opcions[index]['function']();
              },
            );
          }

          List<Llista> llistes =
              snapshot.data.docs.map((e) => Llista.fromDB(e)).toList();

          return Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: llistes.length,
              itemBuilder: (context, index) {
                Llista llista = llistes[index];
                bool isOwner = AuthService().userId == llista.idCreador;
                return Card(
                  child: ListTile(
                    leading: isOwner
                        ? Icon(
                            Icons.admin_panel_settings,
                            size: 30,
                            color: Colors.red[400],
                          )
                        : Icon(
                            Icons.group,
                            size: 30,
                          ),
                    contentPadding: EdgeInsets.all(3),
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            llista.nom,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ]),
                    subtitle: (llista.descripcio != null)
                        ? Center(
                            child: Text(llista.descripcio),
                          )
                        : null,
                    trailing: construirDesplegable(isOwner),
                  ),
                );
              },
            ),
          );
        }

        // si encara no te dades, mostrem la pagina de carregant
        return Scaffold(
          body: Loading("Carregant les llistes (2/2)..."),
        );
      },
    );
  }
}
