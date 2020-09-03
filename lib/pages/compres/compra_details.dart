import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:compres/pages/compres/edit_compra.dart';
import 'package:compres/services/database.dart';
import 'package:compres/shared/some_error_page.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/models/Compra.dart';
import 'package:compres/models/Tipus/Tipus.dart';
import 'package:compres/models/Prioritat/Prioritat.dart';

class CompraDetails extends StatefulWidget {
  CompraDetails({this.id});
  final String id;

  @override
  _CompraDetailsState createState() => _CompraDetailsState();
}

class _CompraDetailsState extends State<CompraDetails> {
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
    Future<DocumentSnapshot> futureCompres =
        DatabaseService(id: widget.id).getCompresData();

    return FutureBuilder(
        future: futureCompres,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return SomeErrorPage(error: snapshot.error);
          }
          if (snapshot.hasData) {
            DocumentSnapshot doc = snapshot.data;
            Compra compra = Compra.fromDB(doc.data());
            return Scaffold(
              appBar: AppBar(
                title: Text('Propietats de la compra'),
                actions: [
                  IconButton(
                    tooltip: "Editar compra",
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      Map<String, dynamic> resposta = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditCompra(compra: compra.toMap()),
                        ),
                      );
                      if (resposta != null) {
                        resposta.remove('id');
                        DocumentReference doc = FirebaseFirestore.instance
                            .collection('compres')
                            .doc(widget.id);
                        await doc.update(resposta);
                        // El future builder agafarà les dades més recents de la BD
                        // En quant es recarregui l'estat
                        setState(() {});
                      }
                    },
                  ),
                  IconButton(
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
                        DocumentReference doc = FirebaseFirestore.instance
                            .collection('compres')
                            .doc(compra.id);
                        await doc.delete();
                        // Si no hi ha element, podem sortir d'aquesta pantalla
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
              body: Padding(
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
                      "Creat per: ${compra.idCreador ?? "No disponible"}",
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(),
                              Text(
                                "Data Compra: ${readTimestamp(compra.dataCompra, true) ?? "No assignada"}",
                                style: TextStyle(fontSize: 25),
                              ),
                              Divider(),
                              Text(
                                "Comprat per: ${compra.idComprador ?? "No disponible"}",
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          )
                        : Container(),
                    Expanded(child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "ID: ${widget.id}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          // Si encara no hi ha dades
          return Loading("Carregant les dades de la compra...");
        });
  }
}
