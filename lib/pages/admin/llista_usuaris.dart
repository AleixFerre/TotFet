import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:totfet/models/Ban.dart';
import 'package:totfet/models/Usuari.dart';
import 'package:totfet/pages/admin/ban_user.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/llista_buida.dart';

class LlistaUsuaris extends StatefulWidget {
  final List<QueryDocumentSnapshot> usuaris;
  LlistaUsuaris({this.usuaris});
  @override
  _LlistaUsuarisState createState() => _LlistaUsuarisState();
}

class _LlistaUsuarisState extends State<LlistaUsuaris> {
  bool mostrarBanejats = false;
  List<Usuari> usuarisBan = [];
  List<Usuari> usuarisNoBan = [];

  @override
  void initState() {
    super.initState();
    widget.usuaris.forEach((element) {
      if (element.data()['ban'] == null) {
        usuarisNoBan.add(
          Usuari.fromDB(element.id, null, element.data()),
        );
      } else {
        usuarisBan.add(
          Usuari.fromDB(element.id, null, element.data()),
        );
      }
    });
  }

  intercanviarVistaBanejats() {
    setState(() {
      mostrarBanejats = !mostrarBanejats;
    });
  }

  List<PopupMenuEntry<int>> mostrarOpcionsDesplegable(
      List<Map<String, dynamic>> opcions) {
    return opcions
        .map((Map<String, dynamic> opcio) => PopupMenuItem(
            value: opcions.indexOf(opcio),
            child: Row(children: [
              opcio['icon'],
              SizedBox(width: 5),
              Text(opcio['nom']),
            ])))
        .toList();
  }

  PopupMenuButton<int> mostrarOpcions(Usuari usuari) {
    final List<Map<String, dynamic>> opcionsNoBan = [
      {
        "nom": "Fer administrador",
        "icon": Icon(Icons.build),
        "function": () async {
          // Show alert box
          bool admin = await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Vols fer administrador a ${usuari.nom}?'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        'Pensa que aquest administrador pot després fer administrador a altra gent!',
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Cancel·lar',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Fer ADMIN',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );

          // Si admin és null o false, llavors no es fa res
          if (admin == true) {
            await DatabaseService().ferAdmin(usuari.uid);
            setState(() {
              usuarisNoBan[usuarisNoBan.indexOf(usuari)].isAdmin = true;
            });
            return print("S'ha fet administrador a l'usuari correctament!");
          }
        },
      },
      {
        "nom": "Banejar",
        "icon": Icon(Icons.report),
        "function": () async {
          Ban ban = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BanUser(usuari: usuari),
            ),
          );

          // Si ban és null o false, llavors no es fa res
          if (ban != null) {
            ban.banejatPer = AuthService().userId;
            await DatabaseService().banejarUsuari(ban);
            setState(() {
              usuarisNoBan.remove(usuari);
              usuarisBan.add(usuari);
            });
            print("Usuari banejat correctament!");
          }
        },
      },
    ];

    final List<Map<String, dynamic>> opcionsBan = [
      {
        "nom": "Treure ban",
        "icon": Icon(Icons.report_off),
        "function": () async {
          // Show alert box
          bool desbanejar = await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Vols treure el ban a ${usuari.nom}?'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        'Aquest usuari ara podrà accedir de nou a la se va conta.',
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Cancel·lar',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Acceptar',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );

          // Si desbanejar és null o false, llavors no es fa res
          if (desbanejar == true) {
            await DatabaseService().desbanejarUsuari(usuari.uid);
            setState(() {
              usuarisBan.remove(usuari);
              usuarisNoBan.add(usuari);
            });
            return print("Usuari desbanejat correctament!");
          }
        },
      },
    ];

    return PopupMenuButton<int>(
      tooltip: "Opcions de l'usuari",
      icon: Icon(Icons.more_vert),
      itemBuilder: mostrarBanejats
          ? (context) => mostrarOpcionsDesplegable(opcionsBan)
          : (context) => mostrarOpcionsDesplegable(opcionsNoBan),
      onSelected: (value) => mostrarBanejats
          ? opcionsBan[value]['function']()
          : opcionsNoBan[value]['function'](),
    );
  }

  @override
  Widget build(BuildContext context) {
    int mida = mostrarBanejats ? usuarisBan.length : usuarisNoBan.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mostrarBanejats ? "Usuaris banejats" : "Tots els Usuaris",
        ),
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
        actions: [
          IconButton(
            tooltip: mostrarBanejats
                ? "Mostrar Usuaris"
                : "Mostrar Usuaris Banejats",
            icon: mostrarBanejats ? Icon(Icons.report_off) : Icon(Icons.report),
            onPressed: () => intercanviarVistaBanejats(),
          ),
        ],
      ),
      // backgroundColor: mostrarBanejats ? Colors.red[50] : Colors.white,
      body: mida == 0
          ? LlistaBuida(esTaronja: false)
          : ListView.builder(
              itemCount: mida,
              itemBuilder: (context, index) {
                Usuari usuari =
                    mostrarBanejats ? usuarisBan[index] : usuarisNoBan[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  elevation: 3,
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(usuari.nom),
                        if (usuari.isAdmin)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.build,
                              color: Colors.indigo[300],
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    leading: Usuari.getAvatar(usuari.nom, usuari.uid, false),
                    trailing: !usuari.isAdmin ? mostrarOpcions(usuari) : null,
                  ),
                );
              },
            ),
    );
  }
}
