import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totfet/models/Usuari.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/llista_buida.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:flutter/material.dart';

class CanviarHost extends StatefulWidget {
  final String idLlista;
  CanviarHost({this.idLlista});

  @override
  _CanviarHostState createState() => _CanviarHostState();
}

class _CanviarHostState extends State<CanviarHost> {
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

          String getNom(String id) {
            return llistaUsuaris
                .where((element) => element.uid == id)
                .first
                .nom;
          }

          llistaUsuaris.removeWhere(
              (Usuari element) => element.uid == AuthService().userId);

          if (llistaUsuaris.length == 0) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Canviar de host"),
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

          // idSeleccionat = llistaUsuaris[0].uid;

          return Scaffold(
            appBar: AppBar(
              title: Text("Canviar de host"),
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
                        "Selecciona l'usuari al que vols transferir el host.",
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
                            child: Row(
                              children: [
                                Usuari.getAvatar(
                                  user.nom,
                                  user.uid,
                                  false,
                                  user.teFoto,
                                ),
                                SizedBox(width: 10),
                                Text(user.nom),
                              ],
                            ),
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
                  onPressed: () async {
                    if (idSeleccionat == null) return Navigator.pop(context);

                    bool res = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                            "Segur que vols transferir el host a ${getNom(idSeleccionat)}?"),
                        content: Text("Aquesta acció et rebocarà els permisos" +
                            "d'administrador de la llista i els transferirà" +
                            " al nou host."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text("CANCEL·LAR"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text(
                              "TRANSFERIR",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (res == true)
                      return Navigator.pop(context, idSeleccionat);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Transferir',
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.face,
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
