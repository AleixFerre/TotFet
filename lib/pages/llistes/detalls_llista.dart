import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/models/Llista.dart';
import 'package:compres/models/Usuari.dart';
import 'package:compres/pages/llistes/QR/qr_viewer.dart';
import 'package:compres/services/database.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/shared/some_error_page.dart';
import 'package:flutter/material.dart';

class LlistaDetalls extends StatelessWidget {
  final Llista llista;
  final bool isOwner;
  LlistaDetalls({this.llista, this.isOwner});
  @override
  Widget build(BuildContext context) {
    Scaffold buildDetalls(List<Usuari> llistaUsuaris) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Detalls de la llista"),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.qr_code),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QRViewer(id: llista.id),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
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
                      child: ListTile(
                        title: Text(
                          llistaUsuaris[index].nom,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 40),
                        ),
                        trailing: llistaUsuaris[index].uid == llista.idCreador
                            ? Icon(Icons.verified_user)
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
          body: Loading("Carregant detalls de la llista..."),
        );
      },
    );
  }
}
