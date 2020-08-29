import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompraView extends StatelessWidget {
  CompraView({this.compra});
  final Map<String, dynamic> compra;

  String readTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    String str = date.day.toString().padLeft(2, "0") +
        "/" +
        date.month.toString().padLeft(2, "0") +
        "/" +
        date.year.toString() +
        " " +
        date.hour.toString().padLeft(2, "0") +
        ":" +
        date.minute.toString().padLeft(2, "0");

    return str;
  }

  @override
  Widget build(BuildContext context) {
    final String key = compra['key'];
    final String nom = compra['nom'].toUpperCase();
    final String tipus = compra['tipus'];
    final String prioritat = compra['prioritat'];
    final int quantitat = compra['quantitat'];
    final int preuEstimat = compra['preuEstimat'];
    final Timestamp dataPrevista = compra['dataPrevista'];
    final String strDataPrevista = readTimestamp(dataPrevista.seconds);
    final Timestamp dataCreacio = compra['dataCreacio'];
    final String strDataCreacio = readTimestamp(dataCreacio.seconds);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Propietats de la compra"),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nom: $nom",
              style: TextStyle(fontSize: 25),
            ),
            Divider(),
            Text(
              "Tipus: $tipus",
              style: TextStyle(fontSize: 25),
            ),
            Divider(),
            Text(
              "Quantitat: $quantitat",
              style: TextStyle(fontSize: 25),
            ),
            Divider(),
            Text(
              "Prioritat: $prioritat",
              style: TextStyle(fontSize: 25),
            ),
            Divider(),
            Text(
              "Preu estimat: $preuEstimat",
              style: TextStyle(fontSize: 25),
            ),
            Divider(),
            Text(
              "Data Prevista: $strDataPrevista",
              style: TextStyle(fontSize: 25),
            ),
            Divider(),
            Text(
              "Data Creació: $strDataCreacio",
              style: TextStyle(fontSize: 25),
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "ID: $key",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
