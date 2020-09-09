import 'dart:ui';

import 'package:compres/models/Finestra.dart';
import 'package:compres/shared/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuPrincipal extends StatelessWidget {
  final Function canviarFinestra;
  MenuPrincipal({this.canviarFinestra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(canviarFinestra: canviarFinestra),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Menu Principal"),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RaisedButton(
                onPressed: () {
                  canviarFinestra(Finestra.Perfil);
                },
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "images/profile.svg",
                      height: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "El meu Perfil",
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Divider(),
              RaisedButton(
                onPressed: () {
                  canviarFinestra(Finestra.Llista);
                },
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "images/shop.svg",
                      height: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Les meves Compres",
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Divider(),
              RaisedButton(
                onPressed: () {
                  canviarFinestra(Finestra.Tasques);
                },
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "images/todo.svg",
                      height: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Les meves Tasques",
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
