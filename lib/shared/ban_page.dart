import 'package:flutter/material.dart';
import 'package:totfet/models/Ban.dart';
import 'package:totfet/models/Usuari.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';

class BanPage extends StatelessWidget {
  final Ban ban;
  BanPage({this.ban});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService(uid: ban.banejatPer).getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SomeErrorPage(
            error:
                "No s'ha pogut carregar les dades del ban. Estas banejat i hi ha hagut un error.",
          );
        }

        if (snapshot.hasData) {
          Usuari banejador =
              Usuari.fromDB(snapshot.data.id, null, snapshot.data.data());

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("T'han banejat..."),
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Titol del ban",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(ban.titol, style: TextStyle(fontSize: 20)),
                  Divider(
                    height: 30,
                  ),
                  Text(
                    "Descripció del ban",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(ban.descripcio, style: TextStyle(fontSize: 20)),
                  Divider(
                    height: 30,
                  ),
                  Text(
                    "Qui t'ha banejat?",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        banejador.nom,
                        style: TextStyle(fontSize: 20),
                      ),
                      if (banejador.isAdmin)
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
                        )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      AuthService().signOut();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Sortir de la sessió',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                        Icon(
                          Icons.exit_to_app,
                          size: 40,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: Loading(esTaronja: false),
        );
      },
    );
  }
}
