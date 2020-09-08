import 'package:compres/models/Finestra.dart';
import 'package:compres/shared/drawer.dart';
import 'package:flutter/material.dart';

class MenuPrincipal extends StatelessWidget {
  final Function canviarFinestra;
  MenuPrincipal({this.canviarFinestra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(canviarFinestra: canviarFinestra),
      appBar: AppBar(
        title: Center(
          child: Text("Menu principal"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RaisedButton(
              onPressed: () {
                canviarFinestra(Finestra.Perfil);
              },
              child: Text("Perfil"),
            ),
            RaisedButton(
              onPressed: () {
                canviarFinestra(Finestra.Llista);
              },
              child: Text("Llistes"),
            ),
            RaisedButton(
              onPressed: () {
                canviarFinestra(Finestra.Tasques);
              },
              child: Text("Tasques"),
            ),
          ],
        ),
      ),
    );
  }
}
