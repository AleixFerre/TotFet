import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:totfet/services/auth.dart';
import 'package:totfet/pages/compres/edit_compra.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/models/Compra.dart';
import 'package:totfet/models/Tipus/Tipus.dart';
import 'package:totfet/models/Prioritat/Prioritat.dart';

class CompraDetails extends StatelessWidget {
  CompraDetails({this.id, this.tipus});
  final String id;
  final List<Map<String, String>> tipus;
  String readTimestamp(Timestamp timestamp, bool showHour) {
    if (timestamp == null) return null;

    DateTime date =
        DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);

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
      for (Map<String, String> map in tipus) {
        if (map['id'] == id) {
          return map['nom'];
        }
      }
      return null;
    }

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
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> llistaUsuaris =
                        snapshot.data.docs;

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

                    Compra compra = Compra.fromDB(info);

                    String etsTu(String id) {
                      if (id == AuthService().userId) {
                        return "(Tu)";
                      } else {
                        return "";
                      }
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
                          IconButton(
                            tooltip: "Editar compra",
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              Map<String, dynamic> resposta =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditCompra(compra: compra.toMap()),
                                ),
                              );
                              if (resposta != null) {
                                resposta.remove('id');
                                await DatabaseService()
                                    .editarCompra(id, resposta);
                                print("Compra editada correctament!");
                                // El future builder agafarà les dades més recents de la BD
                                // En quant es recarregui l'estat
                              }
                            },
                          ),
                          IconButton(
                            tooltip: "Esborrar compra",
                            icon: Icon(Icons.delete),
                            onPressed: () async {
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
                              if (esborrar == true) {
                                DatabaseService().esborrarCompra(id);
                                // Si no hi ha element, podem sortir d'aquesta pantalla
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                      body: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Nom: ${compra.nom}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Tipus: ${tipusToString(compra.tipus)}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Quantitat: ${compra.quantitat}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Prioritat: ${prioritatToString(compra.prioritat)}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Preu estimat: ${compra.preuEstimat ?? "No assignat"}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Data Prevista: ${readTimestamp(compra.dataPrevista, false) ?? "No assignada"}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Data Creació: ${readTimestamp(compra.dataCreacio, true) ?? "No assignada"}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Creat per: ${compra.nomCreador ?? "No disponible"} ${etsTu(compra.idCreador)}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Llista: ${buscarNom(compra.idLlista) ?? "No disponible"}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Assignat a: ${compra.nomAssignat ?? "Ningú"} ${etsTu(compra.idAssignat)}",
                                style: TextStyle(fontSize: 25),
                              ),
                              SizedBox(height: 30),
                              Text(
                                "Dades de la compra",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Divider(),
                              Text(
                                "Comprat: ${compra.comprat ? 'SI' : 'NO'}",
                                style: TextStyle(fontSize: 25),
                              ),
                              compra.comprat
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Divider(),
                                        Text(
                                          "Data Compra: ${readTimestamp(compra.dataCompra, true) ?? "No assignada"}",
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        Divider(),
                                        Text(
                                          "Comprat per: ${compra.nomComprador ?? "No disponible"} ${etsTu(compra.idComprador)}",
                                          style: TextStyle(fontSize: 25),
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
                                    style: TextStyle(fontSize: 20),
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
                });
          }

          // Si encara no hi ha dades
          return Scaffold(
            body: Loading(
              msg: "Carregant les dades de la compra (1/2)...",
              esTaronja: false,
            ),
          );
        });
  }
}
