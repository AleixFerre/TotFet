import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/models/Llista.dart';
import 'package:compres/services/database.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/shared/some_error_page.dart';
import 'package:flutter/material.dart';

class AdminLlistes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Administrador de llistes"),
        ),
      ),
      body: StreamBuilder(
        stream: DatabaseService().getLlistesData(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return SomeErrorPage(error: snapshot.error);
          }

          if (snapshot.hasData) {
            List<Llista> llistes =
                snapshot.data.docs.map((e) => Llista.fromDB(e)).toList();
            return Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: llistes.length,
                itemBuilder: (context, index) {
                  Llista llista = llistes[index];
                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(3),
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              llista.nom,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ]),
                      subtitle: (llista.descripcio != null)
                          ? Center(
                              child: Text(llista.descripcio),
                            )
                          : null,
                      trailing: IconButton(
                          icon: Icon(Icons.more_vert), onPressed: () {}),
                    ),
                  );
                },
              ),
            );
          }

          // si encara no te dades, mostrem la pagina de carregant
          return Scaffold(
            body: Loading("Carregant llistes..."),
          );
        },
      ),
    );
  }
}
