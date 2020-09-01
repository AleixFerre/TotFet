import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:llista_de_la_compra/pages/compres/llista_compra.dart';
import 'package:llista_de_la_compra/pages/generic/loading.dart';
import 'package:llista_de_la_compra/pages/generic/some_error_page.dart';

class CarregarBD extends StatefulWidget {
  @override
  _CarregarBDState createState() => _CarregarBDState();
}

class _CarregarBDState extends State<CarregarBD> {
  bool comprat = false;

  void rebuildParent(bool _comprat) {
    if (comprat != _comprat) {
      setState(() {
        comprat = _comprat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Query productes = FirebaseFirestore.instance
        .collection('productes')
        .where("comprat", isEqualTo: comprat);
    return StreamBuilder<QuerySnapshot>(
      stream: productes.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // SI HI HA HAGUT ALGUN ERROR
        if (snapshot.hasError) {
          return SomeErrorPage(
            error: snapshot.error.toString(),
          );
        }

        // APP CARREGADA CORECTAMENT
        if (snapshot.hasData) {
          List<Map<String, dynamic>> info = snapshot.data.docs.map((doc) {
            Map<String, dynamic> d = doc.data();
            d.putIfAbsent("key", () => doc.id);
            return d;
          }).toList();

          return LlistaCompra(
              llista: info, rebuildParent: rebuildParent, comprat: comprat);
        }

        // LOADING
        return Loading("Connectant-se a la base de dades...");
      },
    );
  }
}
