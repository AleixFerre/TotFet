import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:totfet/models/Llista.dart';
import 'package:totfet/models/Usuari.dart';

import 'package:totfet/services/auth.dart';
import 'package:totfet/pages/compres/edit_compra.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/models/Compra.dart';
import 'package:totfet/models/Tipus.dart';
import 'package:totfet/models/Prioritat.dart';

class CompraDetails extends StatelessWidget {
  CompraDetails({this.id, this.tipus});
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
    Stream<DocumentSnapshot> futureCompres =
        DatabaseService(id: id).getCompresData();

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
        "function": (Compra compra, BuildContext context) async {
          Map<String, dynamic> resposta = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditCompra(compra: compra),
            ),
          );
          if (resposta != null) {
            resposta.remove('id');
            await DatabaseService().editarCompra(id, resposta);
            print("Compra editada correctament!");
            // El future builder agafarà les dades més recents de la BD
            // En quant es recarregui l'estat
          }
        },
      },
      {
        "nom": "Esborrar",
        "icon": Icon(Icons.delete, color: Colors.black),
        "function": (Compra compra, BuildContext context) async {
          // Show alert box
          bool esborrar = await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Vols esborrar la compra?'),
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
            DatabaseService().esborrarCompra(id);
            // Si no hi ha element, podem sortir d'aquesta pantalla
            Navigator.pop(context);
          }
        },
      },
    ];
    final List<Map<String, dynamic>> opcionsExtra = [
      {
        "nom": "Revertir compra",
        "icon": Icon(Icons.assignment_return, color: Colors.black),
        "function": (Compra compra, BuildContext context) async {
          bool revertir = await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Vols revertir la compra?'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        'Aquesta opció marcarà la compra com a NO comprada!',
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
            DatabaseService().revertirCompra(id);
            Navigator.pop(context);
          }
        },
      },
    ];

    return StreamBuilder<DocumentSnapshot>(
      stream: futureCompres,
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshotDetails) {
        if (snapshotDetails.hasError) {
          print(snapshotDetails.error);
          return SomeErrorPage(error: snapshotDetails.error);
        }
        if (snapshotDetails.hasData) {
          Map<String, dynamic> info = snapshotDetails.data.data();
          if (info == null) {
            return Scaffold(
              body: Loading(
                msg: "Esborrant compra...",
                esTaronja: false,
              ),
            );
          }

          List<String> idUsuaris = [
            info['idCreador'],
          ];

          if (info['idComprador'] != null) {
            idUsuaris.add(info['idComprador']);
          }

          if (info['idAssignat'] != null) {
            idUsuaris.add(info['idAssignat']);
          }

          return FutureBuilder<QuerySnapshot>(
            future: DatabaseService().getUsersData(idUsuaris),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot> llistaUsuaris = snapshot.data.docs;

                String getNom(String id) {
                  if (id == null) return null;
                  for (QueryDocumentSnapshot doc in llistaUsuaris) {
                    if (doc.id == id) {
                      return doc.data()['nom'];
                    }
                  }
                  return null;
                }

                info['nomCreador'] = getNom(info['idCreador']);
                info['nomAssignat'] = getNom(info['idAssignat']);
                info['nomComprador'] = getNom(info['idComprador']);

                Compra compra = Compra.fromDB(info, info['id']);

                String mostrarNom(String id, String nom) {
                  if (id == null) return null;

                  if (id == AuthService().userId) {
                    return "$nom (Tu)";
                  } else {
                    return nom;
                  }
                }

                List<Map<String, dynamic>> opcions = opcionsBase;
                if (compra.comprat) {
                  opcions.addAll(opcionsExtra);
                }

                return Scaffold(
                  appBar: AppBar(
                    title: Text('Propietats de la compra'),
                    centerTitle: true,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Colors.blue[400],
                            Colors.blue[900],
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
                          return opcions[index]['function'](compra, context);
                        },
                      ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showParam(
                            "Nom",
                            compra.nom,
                            null,
                          ),
                          showParam(
                            "Descripció",
                            compra.descripcio,
                            null,
                          ),
                          showParam(
                            "Tipus",
                            tipusToString(compra.tipus),
                            tipustoIcon(compra.tipus),
                          ),
                          showParam(
                            "Quantitat",
                            compra.quantitat.toString(),
                            null,
                          ),
                          showParam(
                            "Prioritat",
                            prioritatToString(compra.prioritat),
                            prioritatIcon(compra.prioritat),
                          ),
                          showParam(
                            "Preu estimat",
                            mostrarPreu(compra.preuEstimat),
                            null,
                          ),
                          showParam(
                            "Data prevista",
                            readTimestamp(compra.dataPrevista, false),
                            null,
                          ),
                          showParam(
                            "Data i hora de creació",
                            readTimestamp(compra.dataCreacio, true),
                            null,
                          ),
                          showParam(
                            "Llista",
                            buscarNom(compra.idLlista),
                            null,
                          ),
                          showParam(
                            "Creador",
                            mostrarNom(compra.idCreador, compra.nomCreador),
                            Usuari.getAvatar(
                                compra.nomCreador, compra.idCreador, false),
                          ),
                          showParam(
                            "Assignat a",
                            mostrarNom(compra.idAssignat, compra.nomAssignat),
                            compra.idAssignat != null
                                ? Usuari.getAvatar(compra.nomAssignat,
                                    compra.idAssignat, false)
                                : null,
                          ),
                          showParam(
                            "Comprat",
                            compra.comprat ? 'SI' : 'NO',
                            null,
                          ),
                          compra.comprat
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    showParam(
                                      "Data de compra",
                                      readTimestamp(compra.dataCompra, true),
                                      null,
                                    ),
                                    showParam(
                                      "Comprat per",
                                      mostrarNom(compra.idComprador,
                                          compra.nomComprador),
                                      compra.idComprador != null
                                          ? Usuari.getAvatar(
                                              compra.nomComprador,
                                              compra.idComprador,
                                              false)
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
                  msg: "Carregant les dades de la compra (2/2)...",
                  esTaronja: false,
                ),
              );
            },
          );
        }

        // Si encara no hi ha dades
        return Scaffold(
          body: Loading(
            msg: "Carregant les dades de la compra (1/2)...",
            esTaronja: false,
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

  String mostrarPreu(int preu) {
    return preu == null ? null : preu.toString() + "€";
  }
}
