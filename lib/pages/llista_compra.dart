import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llista_de_la_compra/models/Prioritat/PrioritatColors.dart';
import 'package:llista_de_la_compra/models/Tipus/TipusEmojis.dart';
import 'package:llista_de_la_compra/pages/compra_view.dart';
import 'package:llista_de_la_compra/pages/create_compra.dart';

class LlistaCompra extends StatefulWidget {
  LlistaCompra({this.llista});

  final List<Map<String, dynamic>> llista;

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
                "No hi ha compres per a fer...",
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> compra = list[index];
                final key = compra['key'];
                final Icon tipusIcon =
                    TipusEmojis(tipus: compra['tipus']).toIcon();
                final Color cardColor =
                    PrioritatColor(prioritat: compra['prioritat']).toColor();
                final String prioritatString =
                    PrioritatColor(prioritat: compra['prioritat']).toString();

                return Dismissible(
                  key: Key("$key"),
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
                        .doc(key);
                    await document.update({"comprat": true});
                    setState(() {
                      print("Producte comprat correctament!");
                    });
                  },
                  child: Card(
                    color: cardColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          // Icon segons el tipus
                          leading: tipusIcon,
                          onLongPress: () {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("ID: $key"),
                            ));
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CompraView(compra: compra),
                              ),
                            );
                          },
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 20, 0, 20),
                          isThreeLine: true,
                          title: Center(
                            child: Text(
                              compra['nom'].toUpperCase() +
                                  " · ${compra['quantitat']}",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Center(
                            child: Text(
                              prioritatString,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          trailing: FlatButton(
                            onPressed: () {},
                            child: Icon(Icons.edit),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.blue,
        child: Container(
          height: 60,
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
            await productes
                .add({
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
                })
                .then(
                  (value) => {
                    setState(() {
                      print("Producte afegit correctament");
                    }),
                  },
                )
                .catchError(
                    (error) => print("Error a l'afegir producte: $error"));
          }
        },
        tooltip: 'Afegir un nou element a la llista de la compra',
        child: Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
