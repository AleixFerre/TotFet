import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/pages/llistes/menu_llistes.dart';
import 'package:flutter/material.dart';

import 'package:compres/models/Llista.dart';
import 'package:compres/services/auth.dart';
import 'package:compres/pages/compres/llista_compra.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/shared/some_error_page.dart';

class CarregarBD extends StatefulWidget {
  @override
  _CarregarBDState createState() => _CarregarBDState();
}

class _CarregarBDState extends State<CarregarBD> {
  @override
  Widget build(BuildContext context) {
    // Totes les llistes de l'usuari
    Query getllistes = FirebaseFirestore.instance
        .collection('llistes_usuaris')
        .where("usuari", isEqualTo: AuthService().userId);

    // Carregar llistes de l'usuari actiu
    return FutureBuilder(
      future: getllistes.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<String> llistaDeReferencies = snapshot.data.docs
              .map(
                (doc) => doc.data()['llista'].toString(),
              )
              .toList();

          if (llistaDeReferencies.isEmpty) {
            return MenuLlistes();
          }

          // Agafo la info d'aquestes llistes
          Query getInfoLlistes = FirebaseFirestore.instance
              .collection("llistes")
              .where(FieldPath.documentId, whereIn: llistaDeReferencies);

          return FutureBuilder(
              future: getInfoLlistes.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot2) {
                if (snapshot2.hasData) {
                  List<dynamic> llistaInfo = snapshot2.data.docs
                      .map((QueryDocumentSnapshot doc) => Llista.fromDB(doc))
                      .toList();

                  return BuildStreamCompres(llistes: llistaInfo);
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
  BuildStreamCompres({this.llistes});
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
      setState(() {
        index = _index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Query compres = FirebaseFirestore.instance
        .collection('compres')
        .where("idLlista", isEqualTo: widget.llistes[index].id)
        .where("comprat", isEqualTo: comprat);

    return StreamBuilder<QuerySnapshot>(
      stream: compres.snapshots(),
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
