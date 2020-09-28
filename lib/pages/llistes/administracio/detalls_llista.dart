import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totfet/models/Finestra.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/models/Llista.dart';
import 'package:totfet/models/Usuari.dart';
import 'package:totfet/pages/llistes/administracio/QR/qr_viewer.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';

class LlistaDetalls extends StatelessWidget {
  final Llista llista;
  final bool isOwner;
  final Finestra finestra;
  LlistaDetalls({this.llista, this.isOwner, @required this.finestra});

  @override
  Widget build(BuildContext context) {
    String etsTu(String id) {
      if (id == AuthService().userId) {
        return " (Tu)";
      } else {
        return "";
      }
    }

    void _mostrarPerfilBottomSheet(Usuari usuari) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  "Informació de l'usuari",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Divider(),
                Row(
                  children: [
                    usuari.avatar,
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      usuari.nom,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (usuari.isAdmin)
                      Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Tooltip(
                            message: "Administrador",
                            child: Icon(Icons.build),
                          ),
                        ],
                      ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  usuari.bio == "" || usuari.bio == null
                      ? "Sense bio"
                      : usuari.bio,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    Scaffold buildDetalls(List<Usuari> llistaUsuaris) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Detalls de la llista"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: finestra == Finestra.Tasques
                    ? <Color>[
                        Colors.orange[400],
                        Colors.deepOrange[900],
                      ]
                    : <Color>[
                        Colors.blue[400],
                        Colors.blue[900],
                      ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.qr_code),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QRViewer(
                      id: llista.id,
                      finestra: finestra,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nom: ${llista.nom}",
                  style: TextStyle(fontSize: 25),
                ),
                Divider(),
                Text(
                  "Descripció: ${llista.descripcio ?? "Sense descripció"}",
                  style: TextStyle(fontSize: 25),
                ),
                Divider(
                  height: 40,
                ),
                Center(
                  child: Text(
                    "LLISTA D'USUARIS",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 260,
                    child: ListView.builder(
                      itemCount: llistaUsuaris.length,
                      itemBuilder: (BuildContext context, int index) => Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: FlatButton(
                          onPressed: () =>
                              _mostrarPerfilBottomSheet(llistaUsuaris[index]),
                          child: ListTile(
                            leading: Usuari.getAvatar(llistaUsuaris[index].nom,
                                llistaUsuaris[index].uid, false),
                            title: Text(
                              llistaUsuaris[index].nom +
                                  etsTu(llistaUsuaris[index].uid),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: (llistaUsuaris[index].uid ==
                                        AuthService().userId)
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                              ),
                            ),
                            trailing:
                                llistaUsuaris[index].uid == llista.idCreador
                                    ? Icon(Icons.verified_user)
                                    : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return FutureBuilder<QuerySnapshot>(
      future: DatabaseService().getUsuarisLlista(llista.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return SomeErrorPage(
            error: snapshot.error,
          );
        }

        if (snapshot.hasData) {
          // faig coses amb la data
          List<Usuari> llistaUsuaris = snapshot.data.docs
              .map((QueryDocumentSnapshot e) =>
                  Usuari.fromDB(e.id, null, e.data()))
              .toList();
          return buildDetalls(llistaUsuaris);
        }

        return Scaffold(
          body: Loading(
            msg: "Carregant detalls de la llista...",
            esTaronja: finestra == Finestra.Tasques,
          ),
        );
      },
    );
  }
}
