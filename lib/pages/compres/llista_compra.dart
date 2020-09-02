import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'package:compres/models/Prioritat/PrioritatColors.dart';
import 'package:compres/models/Tipus/TipusEmojis.dart';
import 'package:compres/pages/accounts/profile.dart';
import 'package:compres/pages/compres/create_compra.dart';
import 'package:compres/pages/compres/compra_card.dart';
import 'package:compres/services/auth.dart';
import 'package:compres/models/Compra.dart';

class LlistaCompra extends StatefulWidget {
  LlistaCompra({this.llista, this.rebuildParent, this.comprat});

  final List<Map<String, dynamic>> llista;
  final Function rebuildParent;
  final bool comprat;

  @override
  _LlistaCompraState createState() => _LlistaCompraState();
}

class _LlistaCompraState extends State<LlistaCompra> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> list = widget.llista;

    final AuthService _auth = AuthService();

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Center(
          child: Text("Compres"),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            tooltip: "Perfil",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => Perfil()),
              );
            },
          ),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              tooltip: "Sortir de la sessió",
              onPressed: () async {
                // Show alert box
                bool sortir = await showDialog<bool>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Vols sortir de la sessió?'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              'Pots tornar a iniciar sessió quan vulguis!',
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
                            'Sortir',
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

                // Si esborrar és null o false, llavors no es fa res
                if (sortir == true) {
                  await _auth.signOut();
                }
              }),
        ],
      ),
      body: list.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250,
                  child: SvgPicture.asset(
                    "images/empty.svg",
                    alignment: Alignment.topCenter,
                    placeholderBuilder: (context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpinKitCubeGrid(
                            color: Colors.blue,
                            size: 100,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Aquí no hi ha res...",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> compra = list[index];
                final compraKey = compra['key'];
                final Icon tipusIcon =
                    TipusEmojis(tipus: compra['tipus']).toIcon();
                final Color cardColor =
                    PrioritatColor(prioritat: compra['prioritat']).toColor();
                final String prioritatString =
                    PrioritatColor(prioritat: compra['prioritat']).toString();

                return widget.comprat
                    ? CompraCard(
                        cardColor: cardColor,
                        tipusIcon: tipusIcon,
                        compraKey: compraKey,
                        compra: compra,
                        prioritatString: prioritatString)
                    : Dismissible(
                        key: Key("$compraKey"),
                        background: Container(
                          color: Colors.green,
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                        onDismissed: (direction) async {
                          dynamic document = FirebaseFirestore.instance
                              .collection('productes')
                              .doc(compraKey);
                          await document.update({
                            "comprat": true,
                            "idComprador": AuthService().userId,
                            "dataCompra": Timestamp.now(),
                          });
                          setState(() {
                            return Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Producte comprat correctament!"),
                                action: SnackBarAction(
                                  label: "Desfer",
                                  onPressed: () async {
                                    await document.update({
                                      "idComprador": null,
                                      "dataCompra": null,
                                      "comprat": false,
                                    });
                                  },
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          });
                        },
                        child: CompraCard(
                          cardColor: cardColor,
                          tipusIcon: tipusIcon,
                          compraKey: compraKey,
                          compra: compra,
                          prioritatString: prioritatString,
                        ),
                      );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.blue,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(),
                flex: 1,
              ),
              FlatButton(
                onPressed: () {
                  widget.rebuildParent(false);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      !widget.comprat
                          ? Icons.shop_two
                          : Icons.shop_two_outlined,
                      color: Colors.white,
                      size: !widget.comprat ? 30 : 20,
                    ),
                    Text(
                      "Per comprar",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
                flex: 3,
              ),
              FlatButton(
                onPressed: () {
                  widget.rebuildParent(true);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.comprat
                          ? Icons.monetization_on
                          : Icons.monetization_on_outlined,
                      color: Colors.white,
                      size: widget.comprat ? 30 : 20,
                    ),
                    Text(
                      "Comprats",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Compra result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateCompra()));

          CollectionReference productes =
              FirebaseFirestore.instance.collection('productes');

          if (result != null) {
            await productes
                .add(
                  result.toDBMap(),
                )
                .catchError(
                  (error) => print("Error a l'afegir producte: $error"),
                );

            print("Producte afegit correctament!");
          }
        },
        tooltip: 'Afegir un nou element a la llista de la compra',
        child: Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
