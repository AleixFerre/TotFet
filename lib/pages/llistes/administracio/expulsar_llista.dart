import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:totfet/models/Usuari.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/llista_buida.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';

class ExpulsarDeLlista extends StatefulWidget {
  final String idLlista;
  ExpulsarDeLlista({this.idLlista});

  @override
  _ExpulsarDeLlistaState createState() => _ExpulsarDeLlistaState();
}

class _ExpulsarDeLlistaState extends State<ExpulsarDeLlista> {
  String idSeleccionat;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: DatabaseService().getUsuarisLlista(widget.idLlista),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return SomeErrorPage(error: snapshot.error);
        }

        if (snapshot.hasData) {
          List<Usuari> llistaUsuaris = snapshot.data.docs
              .map((QueryDocumentSnapshot e) =>
                  Usuari.fromDB(e.id, null, e.data()))
              .toList();

          llistaUsuaris.removeWhere(
              (Usuari element) => element.uid == AuthService().userId);

          if (llistaUsuaris.length == 0) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Expulsar un membre"),
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
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LlistaBuida(
                  missatge: "Sembla que no hi ha ningú...",
                  esTaronja: false,
                ),
              ),
            );
          }

          idSeleccionat = llistaUsuaris[0].uid;
          return Scaffold(
            appBar: AppBar(
              title: Text("Expulsar un membre"),
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
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Selecciona l'usuari que vols fer fora.",
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        hint: Text("Escolleix un usuari"),
                        value: idSeleccionat,
                        items: llistaUsuaris
                            .map<DropdownMenuItem<String>>((Usuari user) {
                          return DropdownMenuItem<String>(
                            value: user.uid,
                            child: Text(user.nom),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          setState(() {
                            idSeleccionat = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  onPressed: () {
                    return Navigator.pop(context, idSeleccionat);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Expulsar',
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.gavel,
                        size: 40,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        // Si està carregant la info encara...
        return Scaffold(
          body: Loading(
            msg: "Carregant usuaris...",
            esTaronja: false,
          ),
        );
      },
    );
  }
}
