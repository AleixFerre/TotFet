import 'package:flutter/material.dart';

import 'package:compres/pages/compres/compra_details.dart';
import 'package:compres/services/database.dart';
import 'package:compres/pages/compres/edit_compra.dart';

class CompraCard extends StatelessWidget {
  const CompraCard({
    Key key,
    @required this.tipus,
    @required this.cardColor,
    @required this.tipusIcon,
    @required this.compraKey,
    @required this.compra,
    @required this.prioritatString,
  }) : super(key: key);

  final Color cardColor;
  final Icon tipusIcon;
  final dynamic compraKey;
  final Map<String, dynamic> compra;
  final List<Map<String, dynamic>> tipus;
  final String prioritatString;

  @override
  Widget build(BuildContext context) {
    return compra.isNotEmpty // En quant es pugui mostrar
        ? Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            color: cardColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  // Icon segons el tipus
                  leading: tipusIcon,
                  onLongPress: () {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("ID: $compraKey"),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompraDetails(
                          id: compraKey,
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
                        compra['nom'].toUpperCase() +
                            " · ${compra['quantitat']}",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  subtitle: prioritatString == ""
                      ? Container()
                      : Center(
                          child: Text(
                            prioritatString,
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
                            .editarCompra(compraKey, resposta);
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
