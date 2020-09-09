import 'package:compres/shared/drawer.dart';
import 'package:compres/shared/loading.dart';
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
      drawer: MyDrawer(canviarFinestra: canviarFinestra),
      body: Loading("Tasques en desenvolupament"),
    );
  }
}
