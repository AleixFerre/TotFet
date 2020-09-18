import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totfet/models/Finestra.dart';
import 'package:totfet/pages/llistes/menu_llistes.dart';
import 'package:totfet/pages/tasques/llista_tasques.dart';
import 'package:totfet/services/database.dart';
import 'package:flutter/material.dart';

import 'package:totfet/models/Llista.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';

class Tasques extends StatefulWidget {
  final Function canviarFinestra;
  Tasques({this.canviarFinestra});

  @override
  _TasquesState createState() => _TasquesState();
}

class _TasquesState extends State<Tasques> {
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
            return MenuLlistes(
              canviarFinestra: widget.canviarFinestra,
              finestra: Finestra.Tasques,
            );
          }

          return StreamBuilder(
              stream: DatabaseService().getInfoLlistesIn(llistaDeReferencies),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot2) {
                if (snapshot2.hasData) {
                  List<Llista> llistaInfo = snapshot2.data.docs
                      .map((QueryDocumentSnapshot doc) => Llista.fromDB(doc))
                      .toList();

                  return BuildStreamTasques(
                    llistes: llistaInfo,
                    canviarFinestra: widget.canviarFinestra,
                  );
                }
                return Scaffold(
                  body: Loading(
                      msg: "Carregant informacio de les llistes...",
                      esTaronja: true),
                );
              });
        }

        return Scaffold(
          body: Loading(
            msg: "Carregant llistes...",
            esTaronja: true,
          ),
        );
      },
    );
  }
}

class BuildStreamTasques extends StatefulWidget {
  final List<Llista> llistes;
  final Function canviarFinestra;
  BuildStreamTasques({this.llistes, this.canviarFinestra});
  @override
  _BuildStreamTasquesState createState() => _BuildStreamTasquesState();
}

class _BuildStreamTasquesState extends State<BuildStreamTasques> {
  bool fet = false;
  int index = 0;

  void rebuildParentFet(bool _fet) {
    if (fet != _fet) {
      setState(() {
        fet = _fet;
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
      stream:
          DatabaseService().getTasquesInfoWhere(widget.llistes[index].id, fet),
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

          return LlistaTasques(
            llista: infoLlistes,
            indexLlista: index,
            rebuildParentFet: rebuildParentFet,
            rebuildParentFiltre: rebuildParentFiltre,
            fet: fet,
            llistesUsuari: Llista.llistaPairs(widget.llistes),
            canviarFinestra: widget.canviarFinestra,
          );
        }

        // LOADING
        return Scaffold(
          body: Loading(
            msg: "Carregant les tasques de la llista...",
            esTaronja: true,
          ),
        );
      },
    );
  }
}
