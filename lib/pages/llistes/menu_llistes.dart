import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:totfet/models/Finestra.dart';
import 'package:totfet/models/Llista.dart';
import 'package:totfet/shared/drawer.dart';
import 'package:totfet/pages/llistes/crear_llista.dart';
import 'package:totfet/pages/llistes/unirse_llista.dart';
import 'package:totfet/services/database.dart';

class MenuLlistes extends StatefulWidget {
  final Function canviarFinestra;
  final Finestra finestra;
  MenuLlistes({this.canviarFinestra, @required this.finestra});

  @override
  _MenuLlistesState createState() => _MenuLlistesState();
}

class _MenuLlistesState extends State<MenuLlistes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(
        canviarFinestra: widget.canviarFinestra,
        actual: widget.finestra,
      ),
      appBar: AppBar(
        title: Text("Menu de llistes"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.finestra == Finestra.Tasques
                  ? <Color>[
                      Colors.orange[400],
                      Colors.deepOrange[900],
                    ]
                  : <Color>[
                      Colors.blue[400],
                      Colors.blue[900],
                    ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Bé, sembla que no tens cap llista...",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            "Escolleix una d'aquestes opcions.",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tooltip(
                message: "Crea una llista nova i uneix-te a ella!",
                preferBelow: true,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  elevation: 3,
                  onPressed: () async {
                    Llista llista = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              CrearLlista(finestra: widget.finestra)),
                    );

                    if (llista != null) {
                      await DatabaseService().addList(llista);
                      print("Llista creada correctament!");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          widget.finestra == Finestra.Compres
                              ? "images/create.svg"
                              : "images/create_tasques.svg",
                          height: 100,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Crear",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: "Uneix-te a una llista existent!",
                preferBelow: true,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  elevation: 3,
                  onPressed: () async {
                    String id = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              UnirseLlista(finestra: widget.finestra)),
                    );
                    if (id != null) {
                      await DatabaseService().addUsuariLlista(id);
                      print("T'has unit a la llista correctament!");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          widget.finestra == Finestra.Compres
                              ? "images/join.svg"
                              : "images/join_tasques.svg",
                          height: 100,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Unir-me",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w300),
                        ),
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
