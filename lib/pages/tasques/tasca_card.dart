import 'package:flutter/material.dart';
import 'package:totfet/models/Llista.dart';
import 'package:totfet/models/Tasca.dart';

import 'package:totfet/pages/tasques/tasca_details.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/pages/tasques/edit_tasca.dart';

class TascaCard extends StatelessWidget {
  const TascaCard({
    Key key,
    @required this.tipus,
    @required this.tasca,
  }) : super(key: key);

  final Tasca tasca;
  final List<Llista> tipus;

  @override
  Widget build(BuildContext context) {
    String nom = tasca.nom;
    if (tasca.tempsEstimat != null && !tasca.tempsEstimat.esZero()) {
      nom += " · " + tasca.tempsEstimat?.toString();
    }

    return tasca.id != null // En quant es pugui mostrar
        ? Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            elevation: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onLongPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("ID: ${tasca.id}"),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TascaDetails(
                          id: tasca.id,
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
                  subtitle: tasca.descripcio == "" || tasca.descripcio == null
                      ? Container()
                      : Center(
                          child: Text(
                            tasca.descripcio ?? "",
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
                        await DatabaseService().editarTasca(tasca.id, resposta);
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
