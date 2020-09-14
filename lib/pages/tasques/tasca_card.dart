import 'package:flutter/material.dart';

import 'package:totfet/pages/tasques/tasca_details.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/pages/tasques/edit_tasca.dart';

class TascaCard extends StatelessWidget {
  const TascaCard({
    Key key,
    @required this.tipus,
    @required this.cardColor,
    @required this.tipusIcon,
    @required this.tascaKey,
    @required this.tasca,
    @required this.prioritatString,
  }) : super(key: key);

  final Color cardColor;
  final Icon tipusIcon;
  final dynamic tascaKey;
  final Map<String, dynamic> tasca;
  final List<Map<String, dynamic>> tipus;
  final String prioritatString;

  @override
  Widget build(BuildContext context) {
    String nom = tasca['nom'];
    if (tasca['tempsEstimat'] != null) {
      nom += " · " + tasca['tempsEstimat'].toString() + "h";
    }

    return tasca.isNotEmpty // En quant es pugui mostrar
        ? Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            color: cardColor,
            elevation: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  // Icon segons el tipus
                  leading: tipusIcon,
                  onLongPress: () {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("ID: $tascaKey"),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TascaDetails(
                          id: tascaKey,
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
                        nom,
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
                          builder: (context) => EditTasca(
                            tasca: tasca,
                          ),
                        ),
                      );
                      if (resposta != null) {
                        resposta.remove('key');
                        await DatabaseService().editarTasca(tascaKey, resposta);
                        print("Tasca editada correctament!");
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
