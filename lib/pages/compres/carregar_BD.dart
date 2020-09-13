import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:totfet/services/database.dart';
import 'package:totfet/pages/llistes/menu_llistes.dart';
import 'package:totfet/models/Llista.dart';
import 'package:totfet/pages/compres/llista_compra.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';

class CarregarBD extends StatefulWidget {
  final Function canviarFinestra;
  CarregarBD({this.canviarFinestra});

  @override
  _CarregarBDState createState() => _CarregarBDState();
}

class _CarregarBDState extends State<CarregarBD> {
  @override
  Widget build(BuildContext context) {
    // Carregar llistes de l'usuari actiu
    return StreamBuilder(
      stream: DatabaseService().getLlistesUsuarisActualData(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<String> llistaDeReferencies = snapshot.data.docs
              .map(
                (doc) => doc.data()['llista'].toString(),
              )
              .toList();

          if (llistaDeReferencies.isEmpty) {
            return MenuLlistes(canviarFinestra: widget.canviarFinestra);
          }

          return StreamBuilder(
              stream: DatabaseService().getInfoLlistesIn(llistaDeReferencies),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot2) {
                if (snapshot2.hasData) {
                  List<Llista> llistaInfo = snapshot2.data.docs
                      .map((QueryDocumentSnapshot doc) => Llista.fromDB(doc))
                      .toList();

                  return BuildStreamCompres(
                    llistes: llistaInfo,
                    canviarFinestra: widget.canviarFinestra,
                  );
                }
                return Scaffold(
                  body: Loading("Carregant informacio de les llistes..."),
                );
              });
        }

        return Scaffold(
          body: Loading("Carregant llistes..."),
        );
      },
    );
  }
}

class BuildStreamCompres extends StatefulWidget {
  final List<Llista> llistes;
  final Function canviarFinestra;
  BuildStreamCompres({this.llistes, this.canviarFinestra});
  @override
  _BuildStreamCompresState createState() => _BuildStreamCompresState();
}

class _BuildStreamCompresState extends State<BuildStreamCompres> {
  bool comprat = false;
  int index = 0;

  void rebuildParentComprat(bool _comprat) {
    if (comprat != _comprat) {
      setState(() {
        comprat = _comprat;
      });
    }
  }

  void rebuildParentFiltre(int _index) {
    if (index != _index) {
      // Si per algun casual s'esborra la ultima llista i estem seleccionant
      // aquesta, l'index de la llista actual és l'anterior
      setState(() {
        index = _index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    index = min(index, widget.llistes.length - 1);

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService()
          .getCompresInfoWhere(widget.llistes[index].id, comprat),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // SI HI HA HAGUT ALGUN ERROR
        if (snapshot.hasError) {
          return SomeErrorPage(
            error: snapshot.error.toString(),
          );
        }

        // APP CARREGADA CORECTAMENT
        if (snapshot.hasData) {
          List<Map<String, dynamic>> infoLlistes =
              snapshot.data.docs.map((QueryDocumentSnapshot doc) {
            Map<String, dynamic> d = doc.data();
            d.putIfAbsent("key", () => doc.id);
            return d;
          }).toList();

          return LlistaCompra(
            llista: infoLlistes,
            indexLlista: index,
            rebuildParentComprat: rebuildParentComprat,
            rebuildParentFiltre: rebuildParentFiltre,
            comprat: comprat,
            llistesUsuari: Llista.llistaPairs(widget.llistes),
            canviarFinestra: widget.canviarFinestra,
          );
        }

        // LOADING
        return Scaffold(
          body: Loading("Carregant les compres de la llista..."),
        );
      },
    );
  }
}
