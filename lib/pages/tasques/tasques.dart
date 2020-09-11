import 'package:compres/models/Finestra.dart';
import 'package:compres/shared/drawer.dart';
import 'package:flutter/material.dart';

class Tasques extends StatelessWidget {
  final Function canviarFinestra;
  Tasques({this.canviarFinestra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasques"),
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
      drawer: MyDrawer(
        canviarFinestra: canviarFinestra,
        actual: Finestra.Tasques,
      ),
      body: Center(
        child: Text(
          "La funcionalitat de Tasques està en desenvolupament fins la propera gran actualització.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
