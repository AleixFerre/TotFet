import 'package:compres/shared/drawer.dart';
import 'package:compres/shared/loading.dart';
import 'package:flutter/material.dart';

class Tasques extends StatelessWidget {
  final Function canviarFinestra;
  Tasques({this.canviarFinestra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(canviarFinestra: canviarFinestra),
      body: Loading("Tasques en desenvolupament"),
    );
  }
}
