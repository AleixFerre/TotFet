import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llista_de_la_compra/models/Prioritat/PrioritatColors.dart';
import 'package:llista_de_la_compra/models/Tipus/TipusEmojis.dart';
import 'package:llista_de_la_compra/pages/create_compra.dart';
import 'compra_card.dart';

class LlistaCompra extends StatefulWidget {
  LlistaCompra({this.llista, this.rebuildParent, this.comprat});

  final List<Map<String, dynamic>> llista;
  final Function rebuildParent;
  final bool comprat;

  @override
  _LlistaCompraState createState() => _LlistaCompraState();
}

class _LlistaCompraState extends State<LlistaCompra> {
  int bottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> list = widget.llista;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Center(
          child: Text("Llista de la compra"),
        ),
      ),
      body: list.isEmpty
          ? Center(
              child: Text(
                widget.comprat
                    ? "No hi ha compres fetes recentment..."
                    : "No hi ha compres per a fer...",
                style: TextStyle(fontSize: 25),
              ),
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
                          await document.update({"comprat": true});
                          setState(() {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Producte comprat correctament!"),
                                action: SnackBarAction(
                                  label: "Desfer",
                                  onPressed: () {
                                    document.update({"comprat": false});
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
                  bottomBarIndex = 0;
                  widget.rebuildParent(false);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      bottomBarIndex == 0
                          ? Icons.shop_two
                          : Icons.shop_two_outlined,
                      color: Colors.white,
                      size: bottomBarIndex == 0 ? 30 : 20,
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
                  bottomBarIndex = 1;
                  widget.rebuildParent(true);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      bottomBarIndex == 1
                          ? Icons.monetization_on
                          : Icons.monetization_on_outlined,
                      color: Colors.white,
                      size: bottomBarIndex == 1 ? 30 : 20,
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
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateCompra()));

          CollectionReference productes =
              FirebaseFirestore.instance.collection('productes');

          if (result != null) {
            await productes.add({
              'nom': result.nom,
              'tipus': result.tipus == null
                  ? "Altres"
                  : result.tipus
                      .toString()
                      .substring(result.tipus.toString().indexOf('.') + 1),
              'quantitat': result.quantitat.toInt(),
              'prioritat': result.prioritat
                  .toString()
                  .substring(result.prioritat.toString().indexOf('.') + 1),
              'dataPrevista': result.data,
              'dataCreacio': DateTime.now(),
              'preuEstimat': result.preuEstimat,
              'comprat': false,
            }).catchError(
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
