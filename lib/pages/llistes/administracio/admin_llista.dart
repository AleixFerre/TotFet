import 'dart:ui';

import 'package:compres/pages/llistes/administracio/expulsar_llista.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:compres/pages/llistes/administracio/QR/qr_viewer.dart';
import 'package:compres/pages/llistes/administracio/canvar_host.dart';
import 'package:compres/pages/llistes/administracio/detalls_llista.dart';
import 'package:compres/models/Llista.dart';
import 'package:compres/pages/llistes/administracio/editar_llista.dart';
import 'package:compres/services/auth.dart';
import 'package:compres/services/database.dart';
import 'package:compres/shared/llista_buida.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/shared/some_error_page.dart';

class AdminLlistes extends StatefulWidget {
  @override
  _AdminLlistesState createState() => _AdminLlistesState();
}

class _AdminLlistesState extends State<AdminLlistes> {
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
          List<Llista> llistes =
              snapshot.data.docs.map((e) => Llista.fromDB(e)).toList();

          PopupMenuButton<int> construirDesplegable(
              bool isOwner, Llista llista) {
            final List<Map<String, dynamic>> opcionsOwner = [
              {
                "nom": "Editar",
                "icon": Icon(Icons.edit),
                "function": () async {
                  Llista resultat = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditarLlista(llista: llista),
                    ),
                  );
                  // Actualitzar la llista a la BD
                  if (resultat != null) {
                    await DatabaseService().updateLlista(resultat);
                    print("Llista editada correctament!");
                  }
                },
              },
              {
                "nom": "Canviar Host",
                "icon": Icon(Icons.face),
                "function": () async {
                  String resultat = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CanviarHost(
                        idLlista: llista.id,
                      ),
                    ),
                  );
                  if (resultat != null) {
                    await DatabaseService().setHost(llista.id, resultat);
                    print("S'ha canviat de host correctament!");
                  }
                },
              },
              {
                "nom": "Expulsar",
                "icon": Icon(Icons.gavel),
                "function": () async {
                  String resultat = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ExpulsarDeLlista(
                        idLlista: llista.id,
                      ),
                    ),
                  );
                  if (resultat != null) {
                    await DatabaseService()
                        .sortirUsuarideLlista(llista.id, resultat);
                    print("Usuari Expulsat correctament");
                  }
                },
              },
            ];
            final List<Map<String, dynamic>> opcionsNormal = [
              {
                "nom": "Sortir",
                "icon": Icon(Icons.exit_to_app),
                "function": () async {
                  // Show alert box
                  bool sortir = await showDialog<bool>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Vols sortir de la llista?'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                'Pots tornar-te a unir amb el codi',
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'Cancel·lar',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'Sortir',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  // Si esborrar és null o false, llavors no es fa res
                  if (sortir == true) {
                    await DatabaseService()
                        .sortirUsuarideLlista(llista.id, AuthService().userId);
                    return print(
                        "L'usuari ha sortit correctament de la llista!");
                  }
                },
              },
            ];

            List<Map<String, dynamic>> opcions =
                isOwner ? opcionsOwner : opcionsNormal;

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

          return Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: llistes.length,
              itemBuilder: (context, index) {
                Llista llista = llistes[index];
                bool isOwner = AuthService().userId == llista.idCreador;
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LlistaDetalls(
                            llista: llista,
                            isOwner: isOwner,
                          ),
                        ),
                      );
                    },
                    leading: IconButton(
                      tooltip:
                          "Ensenya el codi QR als teus amics per poder convidar-los!",
                      icon: Icon(
                        Icons.qr_code_scanner,
                        size: 32,
                        semanticLabel: "Escaneja el codi QR de la llista",
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QRViewer(id: llista.id),
                          ),
                        );
                      },
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
                    trailing: construirDesplegable(isOwner, llista),
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
