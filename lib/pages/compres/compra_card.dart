import 'package:flutter/material.dart';
import 'package:totfet/models/Compra.dart';
import 'package:totfet/models/Llista.dart';
import 'package:totfet/models/Prioritat.dart';
import 'package:totfet/models/Tipus.dart';

import 'package:totfet/pages/compres/compra_details.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/pages/compres/edit_compra.dart';

class CompraCard extends StatelessWidget {
  const CompraCard({
    Key key,
    @required this.tipus,
    @required this.compra,
  }) : super(key: key);

  final Compra compra;
  final List<Llista> tipus;

  @override
  Widget build(BuildContext context) {
    return compra.id != null // En quant es pugui mostrar
        ? Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            elevation: 3,
            color: prioritatColor(compra.prioritat),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  // Icon segons el tipus
                  leading: tipustoIcon(compra.tipus),
                  onLongPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("ID: ${compra.id}"),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompraDetails(
                          id: compra.id,
                          tipus: tipus,
                        ),
                      ),
                    );
                  },
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                  isThreeLine: true,
                  title: Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        compra.nom.toUpperCase() + " · ${compra.quantitat}",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  subtitle: compra.descripcio == "" || compra.descripcio == null
                      ? Container()
                      : Center(
                          child: Text(
                            compra.descripcio ?? "",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                  trailing: FlatButton(
                    onPressed: () async {
                      Map<String, dynamic> resposta = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditCompra(
                            compra: compra,
                          ),
                        ),
                      );
                      if (resposta != null) {
                        resposta.remove('key');
                        await DatabaseService()
                            .editarCompra(compra.id, resposta);
                        print("Compra editada correctament!");
                      }
                    },
                    child: Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
