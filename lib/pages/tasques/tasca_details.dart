import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totfet/models/Llista.dart';

import 'package:totfet/models/Tasca.dart';
import 'package:totfet/models/Usuari.dart';
import 'package:totfet/pages/tasques/edit_tasca.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/models/Prioritat.dart';

class TascaDetails extends StatelessWidget {
  TascaDetails({this.id, this.tipus});
  final String id;
  final List<Llista> tipus;
  String readTimestamp(Timestamp timestamp, bool showHour) {
    if (timestamp == null) return null;

    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
      timestamp.microsecondsSinceEpoch,
    );

    String str = date.day.toString().padLeft(2, "0") +
        "/" +
        date.month.toString().padLeft(2, "0") +
        "/" +
        date.year.toString();

    if (showHour) {
      str += " " +
          date.hour.toString().padLeft(2, "0") +
          ":" +
          date.minute.toString().padLeft(2, "0");
    }

    return str;
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> futureTasques =
        DatabaseService(id: id).getTasquesData();

    String buscarNom(String id) {
      for (Llista map in tipus) {
        if (map.id == id) {
          return map.nom;
        }
      }
      return null;
    }

    final List<Map<String, dynamic>> opcionsBase = [
      {
        "nom": "Editar",
        "icon": Icon(Icons.edit, color: Colors.black),
        "function": (Tasca tasca, BuildContext context) async {
          Map<String, dynamic> resposta = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTasca(tasca: tasca),
            ),
          );
          if (resposta != null) {
            resposta.remove('id');
            await DatabaseService().editarTasca(id, resposta);
            print("Tasca editada correctament!");
            // El future builder agafarà les dades més recents de la BD
            // En quant es recarregui l'estat
          }
        },
      },
      {
        "nom": "Esborrar",
        "icon": Icon(Icons.delete, color: Colors.black),
        "function": (Tasca tasca, BuildContext context) async {
          // Show alert box
          bool esborrar = await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Vols esborrar la tasca?'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        'Aquesta acció no es pot desfer!',
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
                      'Esborrar',
                      style: TextStyle(fontSize: 20, color: Colors.red[400]),
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
          if (esborrar == true) {
            DatabaseService().esborrarTasca(tasca.id);
            // Si no hi ha element, podem sortir d'aquesta pantalla
            Navigator.pop(context);
          }
        },
      },
    ];
    final List<Map<String, dynamic>> opcionsExtra = [
      {
        "nom": "Revertir tasca",
        "icon": Icon(Icons.assignment_return, color: Colors.black),
        "function": (compra, context) async {
          bool revertir = await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Vols revertir la tasca?'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        'Aquesta opció marcarà la tasca com a NO feta!',
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
                      'Revertir',
                      style: TextStyle(fontSize: 20, color: Colors.red[400]),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );
          if (revertir == true) {
            DatabaseService().revertirTasca(id);
            Navigator.pop(context);
          }
        },
      },
    ];

    return StreamBuilder<DocumentSnapshot>(
      stream: futureTasques,
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshotDetails) {
        if (snapshotDetails.hasError) {
          print(snapshotDetails.error);
          return SomeErrorPage(error: snapshotDetails.error);
        }
        if (snapshotDetails.hasData) {
          Tasca tasca = Tasca.fromDB(
            snapshotDetails.data.data(),
            snapshotDetails.data.id,
          );

          if (tasca.id == null) {
            return Scaffold(
              body: Loading(
                msg: "Esborrant tasca...",
                esTaronja: true,
              ),
            );
          }

          List<String> idUsuaris = [
            tasca.idCreador,
          ];

          if (tasca.idUsuariFet != null) {
            idUsuaris.add(tasca.idUsuariFet);
          }

          if (tasca.idAssignat != null) {
            idUsuaris.add(tasca.idAssignat);
          }

          return FutureBuilder<QuerySnapshot>(
            future: DatabaseService().getUsersData(idUsuaris),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
              if (snapshot.hasData) {
                List<Usuari> llistaUsuaris = snapshot.data.docs
                    .map(
                      (e) => Usuari.fromDB(e.id, null, e.data()),
                    )
                    .toList();

                String getNom(String id) {
                  if (id == null) return null;
                  for (Usuari usuari in llistaUsuaris) {
                    if (usuari.uid == id) {
                      return usuari.nom;
                    }
                  }
                  return null;
                }

                tasca.nomCreador = getNom(tasca.idCreador);
                tasca.nomAssignat = getNom(tasca.idAssignat);
                tasca.nomUsuariFet = getNom(tasca.idUsuariFet);

                String mostrarNom(String id, String nom) {
                  if (id == null) return null;

                  if (id == AuthService().userId) {
                    return "$nom (Tu)";
                  } else {
                    return nom;
                  }
                }

                List<Map<String, dynamic>> opcions = opcionsBase;

                if (tasca.fet) {
                  opcions.addAll(opcionsExtra);
                }

                return Scaffold(
                  appBar: AppBar(
                    title: Text('Propietats de la tasca'),
                    centerTitle: true,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Colors.orange[400],
                            Colors.deepOrange[900],
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      PopupMenuButton<int>(
                        tooltip: "Opcions de la compra",
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
                          return opcions[index]['function'](tasca, context);
                        },
                      ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          showParam(
                            "Nom",
                            tasca.nom,
                            null,
                          ),
                          showParam(
                            "Descripció",
                            tasca.descripcio,
                            null,
                          ),
                          showParam(
                            "Prioritat",
                            prioritatToString(tasca.prioritat),
                            prioritatIcon(tasca.prioritat),
                          ),
                          showParam(
                            "Durada estimada",
                            tasca.tempsEstimat?.toString(),
                            null,
                          ),
                          showParam(
                            "Data prevista",
                            readTimestamp(tasca.dataPrevista, false),
                            null,
                          ),
                          showParam(
                            "Data i hora de creació",
                            readTimestamp(tasca.dataCreacio, true),
                            null,
                          ),
                          showParam(
                            "Llista",
                            buscarNom(tasca.idLlista),
                            null,
                          ),
                          showParam(
                            "Creador",
                            mostrarNom(tasca.idCreador, tasca.nomCreador),
                            Usuari.getAvatar(
                                tasca.nomCreador, tasca.idCreador, false),
                          ),
                          showParam(
                            "Assignat a",
                            mostrarNom(tasca.idAssignat, tasca.nomAssignat),
                            tasca.idAssignat != null
                                ? Usuari.getAvatar(
                                    tasca.nomAssignat, tasca.idAssignat, false)
                                : null,
                          ),
                          showParam(
                            "Fet",
                            tasca.fet ? 'SI' : 'NO',
                            null,
                          ),
                          tasca.fet
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    showParam(
                                      "Data de tancament",
                                      readTimestamp(tasca.dataTancament, true),
                                      null,
                                    ),
                                    showParam(
                                      "Fet per",
                                      mostrarNom(tasca.idUsuariFet,
                                          tasca.nomUsuariFet),
                                      tasca.idUsuariFet != null
                                          ? Usuari.getAvatar(tasca.nomUsuariFet,
                                              tasca.idUsuariFet, false)
                                          : null,
                                    ),
                                  ],
                                )
                              : Container(),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "ID: $id",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Scaffold(
                body: Loading(
                  msg: "Carregant les dades de la tasca (2/2)...",
                  esTaronja: true,
                ),
              );
            },
          );
        }

        // Si encara no hi ha dades
        return Scaffold(
          body: Loading(
            msg: "Carregant les dades de la tasca (1/2)...",
            esTaronja: true,
          ),
        );
      },
    );
  }

  Column showParam(String nom, String param, Widget leading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$nom:",
          style: TextStyle(fontSize: 15),
        ),
        if (param == null || param == "")
          Text(
            "No assignat",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Row(
            children: [
              if (leading != null)
                Row(
                  children: [
                    leading,
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              Text(
                param,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        SizedBox(height: 20),
      ],
    );
  }
}
