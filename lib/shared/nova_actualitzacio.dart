import 'package:flutter/material.dart';
import 'package:totfet/models/Actualitzacio.dart';
import 'package:totfet/services/versionControl.dart';
import 'package:url_launcher/url_launcher.dart';

class NovaActualitzacio extends StatelessWidget {
  final Actualitzacio actualitzacio;
  NovaActualitzacio({this.actualitzacio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Nova actualització obligatòria!"),
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
        padding: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Text(
              "Nom de la actualitzacio",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(actualitzacio.longName, style: TextStyle(fontSize: 20)),
            Divider(
              height: 30,
            ),
            Text(
              "Tag la actualitzacio",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(actualitzacio.tag, style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 40,
            ),
            RaisedButton(
              color: Colors.blueAccent,
              onPressed: () async {
                await VersionControlService()
                    .mostrarNotesActualitzacio(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Veure canvis',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Icon(
                    Icons.receipt,
                    size: 40,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.blueAccent,
              onPressed: () async {
                String url = actualitzacio.url;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      titlePadding: const EdgeInsets.all(24),
                      title: Text("No es pot obrir l'enllaç :("),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Actualitzar',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Icon(
                    Icons.update,
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
}
