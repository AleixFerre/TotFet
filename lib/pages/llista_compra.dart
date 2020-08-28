import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llista_de_la_compra/pages/create_compra.dart';

class LlistaCompra extends StatefulWidget {
  LlistaCompra({this.llista});

  final List<Map<String, dynamic>> llista;

  @override
  _LlistaCompraState createState() => _LlistaCompraState();
}

class _LlistaCompraState extends State<LlistaCompra> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> list = widget.llista;
    return Scaffold(
      key: GlobalKey(debugLabel: "llista"),
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

                return Dismissible(
                  key: Key("$key"),
                  background: Container(
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) async {
                    dynamic document = FirebaseFirestore.instance
                        .collection('productes')
                        .doc(key);
                    await document.update({"comprat": true}).set();
                    setState(() {
                      print("Producte comprat correctament!");
                    });
                  },
                  child: ListTile(
                    onLongPress: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("ID: $key"),
                      ));
                    },
                    contentPadding: const EdgeInsets.symmetric(vertical: 30),
                    isThreeLine: true,
                    title: Center(
                      child: Text(
                        compra['nom'].toUpperCase(),
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    subtitle: Center(
                      child: (compra['tipus'] == null)
                          ? Text(
                              "Sense tipus",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )
                          : Text(
                              "${compra['tipus']}",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                    ),
                    trailing: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Text(
                        "${compra['quantitat']}",
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
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
                  'tipus': result.tipus
                      .toString()
                      .substring(result.tipus.toString().indexOf('.') + 1),
                  'quantitat': result.quantitat.toInt(),
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
        child: Icon(Icons.add),
      ),
    );
  }
}
