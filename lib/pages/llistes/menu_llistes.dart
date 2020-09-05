import 'dart:ui';

import 'package:compres/pages/llistes/crear_llista.dart';
import 'package:compres/pages/llistes/unirse_llista.dart';
import 'package:compres/shared/sortir_sessio.dart';
import 'package:flutter/material.dart';

class MenuLlistes extends StatefulWidget {
  @override
  _MenuLlistesState createState() => _MenuLlistesState();
}

class _MenuLlistesState extends State<MenuLlistes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Menu de llistes"),
        ),
        actions: [
          SortirSessio(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(),
          ),
          Text(
            "Bé, sembla que no tens cap llista...",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          Text(
            "Que tal si escolleixes una d'aquestes opcions...?",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tooltip(
                message: "Crea una llista nova i uneix-te a ella!",
                preferBelow: true,
                child: RaisedButton(
                  elevation: 3,
                  onPressed: () async {
                    // FER A FUNCIONALITAT DE PASSAR LA LLISTA A LA BD
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CrearLlista()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.library_add,
                          size: 50,
                        ),
                        Text("Crear"),
                      ],
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: "Uneix-te a una llista existent!",
                preferBelow: true,
                child: RaisedButton(
                  elevation: 3,
                  onPressed: () async {
                    // FER A FUNCIONALITAT DE PASSAR LA RELACIO A LA BD
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UnirseLlista()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.group_add,
                          size: 50,
                        ),
                        Text("Unir-me"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
