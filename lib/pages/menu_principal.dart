import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:totfet/models/Finestra.dart';
import 'package:totfet/shared/drawer.dart';

class MenuPrincipal extends StatelessWidget {
  final Function canviarFinestra;
  MenuPrincipal({this.canviarFinestra});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Vols sortir de la app?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel·lar"),
            ),
            TextButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: Text("Sortir"),
            ),
          ],
        ),
      ),
      child: Scaffold(
        drawer: MyDrawer(
          canviarFinestra: canviarFinestra,
          actual: Finestra.Menu,
        ),
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  canviarFinestra(Finestra.Perfil);
                },
                padding: EdgeInsets.symmetric(vertical: 20),
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
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  canviarFinestra(Finestra.Compres);
                },
                padding: EdgeInsets.symmetric(vertical: 20),
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
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  canviarFinestra(Finestra.Tasques);
                },
                padding: EdgeInsets.symmetric(vertical: 20),
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
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
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
