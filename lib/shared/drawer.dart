import 'package:compres/pages/accounts/profile.dart';
import 'package:compres/pages/compres/carregar_BD.dart';
import 'package:compres/pages/menu_principal.dart';
import 'package:compres/shared/constants.dart';
import 'package:compres/shared/sortir_sessio.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: "Calaix on es guarden totes les opcions importants.",
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue[900],
                Colors.blue[400],
              ]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: 60,
                  color: Colors.white,
                ),
                Text(
                  "Llista de la compra",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: RaisedButton(
                  elevation: 1,
                  color: Colors.grey[100],
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (ctx) => MenuPrincipal()),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.apps),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Menu"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: RaisedButton(
                  elevation: 1,
                  color: Colors.grey[100],
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (ctx) => CarregarBD()),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.list),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Llistes"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: RaisedButton(
                  elevation: 1,
                  color: Colors.grey[100],
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (ctx) => Perfil()),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Perfil"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              Divider(),
              SortirSessio(),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: RaisedButton(
                  elevation: 1,
                  color: Colors.grey[100],
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationIcon:
                          Image.asset("images/favicon.png", height: 50),
                      applicationName: appName,
                      applicationVersion: versionNumber,
                      applicationLegalese: 'Desenvolupat per Aleix Ferré',
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.help),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Més info"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Versió $versionNumber"),
            ],
          ),
        ],
      ),
    );
  }
}
