import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:totfet/models/Tasca.dart';
import 'package:totfet/pages/tasques/edit_tasca.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/models/Prioritat/Prioritat.dart';

class TascaDetails extends StatelessWidget {
  TascaDetails({this.id, this.tipus});
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
    Stream<DocumentSnapshot> futureTasques =
        DatabaseService(id: id).getTasquesData();

    String buscarNom(String id) {
      for (Map<String, String> map in tipus) {
        if (map['id'] == id) {
          return map['nom'];
        }
      }
      return null;
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: futureTasques,
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
                body: Loading("Esborrant tasca..."),
              );
            }

            List<String> idUsuaris = [
              info['idCreador'],
            ];

            if (info['idUsuariFet'] != null) {
              idUsuaris.add(info['idUsuariFet']);
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
                    info['nomUsuariFet'] = getNom(info['nomUsuariFet']);

                    Tasca tasca = Tasca.fromDB(info);

                    String etsTu(String id) {
                      if (id == AuthService().userId) {
                        return "(Tu)";
                      } else {
                        return "";
                      }
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
                          IconButton(
                            tooltip: "Editar tasca",
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              Map<String, dynamic> resposta =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditTasca(tasca: tasca.toMap()),
                                ),
                              );
                              if (resposta != null) {
                                resposta.remove('id');
                                await DatabaseService()
                                    .editarTasca(id, resposta);
                                print("Tasca editada correctament!");
                                // El future builder agafarà les dades més recents de la BD
                                // En quant es recarregui l'estat
                              }
                            },
                          ),
                          IconButton(
                            tooltip: "Esborrar tasca",
                            icon: Icon(Icons.delete),
                            onPressed: () async {
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
                                DatabaseService().esborrarTasca(id);
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
                                "Nom: ${tasca.nom}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Descripcio: ${tasca.descripcio ?? "Sense Descripció"}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Prioritat: ${prioritatToString(tasca.prioritat)}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Temps estimat: ${tasca.tempsEstimat == null ? "No assignat" : tasca.tempsEstimat.toString() + "h"}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Data Prevista: ${readTimestamp(tasca.dataPrevista, false) ?? "No assignada"}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Data Creació: ${readTimestamp(tasca.dataCreacio, true) ?? "No assignada"}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Creat per: ${tasca.nomCreador ?? "No disponible"} ${etsTu(tasca.idCreador)}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Llista: ${buscarNom(tasca.idLlista) ?? "No disponible"}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Assignat a: ${tasca.nomAssignat ?? "Ningú"} ${etsTu(tasca.idAssignat)}",
                                style: TextStyle(fontSize: 25),
                              ),
                              SizedBox(height: 30),
                              Text(
                                "Dades de la tasca",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Divider(),
                              Text(
                                "Fet: ${tasca.fet ? 'SI' : 'NO'}",
                                style: TextStyle(fontSize: 25),
                              ),
                              tasca.fet
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Divider(),
                                        Text(
                                          "Data Tancament: ${readTimestamp(tasca.dataTancament, true) ?? "No assignada"}",
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        Divider(),
                                        Text(
                                          "Fet per: ${tasca.nomUsuariFet ?? "No disponible"}",
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
                    body: Loading("Carregant les dades de la tasca (2/2)..."),
                  );
                });
          }

          // Si encara no hi ha dades
          return Scaffold(
            body: Loading("Carregant les dades de la tasca (1/2)..."),
          );
        });
  }
}
