import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:totfet/models/Finestra.dart';
import 'package:totfet/models/Llista.dart';
import 'package:totfet/models/Tasca.dart';
import 'package:totfet/pages/llistes/administracio/detalls_llista.dart';
import 'package:totfet/pages/tasques/create_tasca.dart';
import 'package:totfet/pages/tasques/tasca_card.dart';
import 'package:totfet/shared/drawer.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/llista_buida.dart';
import 'package:totfet/models/Prioritat/PrioritatColors.dart';
import 'package:totfet/models/Tipus/TipusEmojis.dart';

class LlistaTasques extends StatelessWidget {
  LlistaTasques({
    // llista actual a mostrar
    this.llista,
    // llista de les llistes disponibles pel perfil actual
    this.llistesUsuari,
    // index de la llista actual
    this.indexLlista,
    // Funcio per canviar el valor de l'index de la llista del parent
    this.rebuildParentFiltre,
    // Funcio per canviar el valor Bool de comprat del parent
    this.rebuildParentFet,
    // Bool per si s'esta mostrant les elements comprats o no
    this.fet,
    // Funció a passar al drawer per poder canviar d'escenes
    this.canviarFinestra,
  });

  final List<Map<String, dynamic>> llista;
  final List<Map<String, String>> llistesUsuari;
  final int indexLlista;
  final Function rebuildParentFet;
  final Function rebuildParentFiltre;
  final bool fet;
  final Function canviarFinestra;

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      elevation: 10,
      title: Text(
        "Tasques de ${llistesUsuari[indexLlista]['nom']}",
        overflow: TextOverflow.fade,
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.orange[400],
              Colors.deepOrange[900],
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            Llista infoLlista = Llista.fromMap(llistesUsuari[indexLlista]);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LlistaDetalls(
                  llista: infoLlista,
                  finestra: Finestra.Tasques,
                ),
              ),
            );
          },
        ),
        PopupMenuButton<int>(
          tooltip: "Selecciona una llista",
          icon: Icon(Icons.filter_list),
          onSelected: (int index) {
            rebuildParentFiltre(index);
          },
          initialValue: indexLlista,
          itemBuilder: (BuildContext context) {
            return llistesUsuari
                .map(
                  (Map<String, String> llista) => PopupMenuItem(
                    value: llistesUsuari.indexOf(llista),
                    child: Text(llista['nom']),
                  ),
                )
                .toList();
          },
        ),
      ],
    );

    ListView mostrarLlista = ListView.builder(
      itemCount: llista.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> tasca = llista[index];
        final tascaKey = tasca['key'];
        final Icon tipusIcon = TipusEmojis(tipus: tasca['tipus']).toIcon();
        final Color cardColor =
            PrioritatColor(prioritat: tasca['prioritat']).toColor();
        final String prioritatString =
            PrioritatColor(prioritat: tasca['prioritat']).toString();

        return fet
            ? TascaCard(
                cardColor: cardColor,
                tipusIcon: tipusIcon,
                tascaKey: tascaKey,
                tasca: tasca,
                prioritatString: prioritatString,
                tipus: llistesUsuari,
              )
            : Dismissible(
                key: Key("$tascaKey"),
                background: Container(
                  color: Colors.green,
                  child: Icon(
                    Icons.assignment_turned_in,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                onDismissed: (direction) async {
                  await DatabaseService().completarTasca(tascaKey);
                  print("Tasca completada correctament!");
                },
                child: TascaCard(
                  cardColor: cardColor,
                  tipusIcon: tipusIcon,
                  tascaKey: tascaKey,
                  tasca: tasca,
                  prioritatString: prioritatString,
                  tipus: llistesUsuari,
                ),
              );
      },
    );

    BottomAppBar bottomAppBar = BottomAppBar(
      elevation: 10,
      shape: CircularNotchedRectangle(),
      color: Colors.orange[800],
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
                rebuildParentFet(false);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    !fet ? Icons.assignment : Icons.assignment,
                    color: Colors.white,
                    size: !fet ? 30 : 20,
                  ),
                  Text(
                    "Per fer",
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
                rebuildParentFet(true);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    fet
                        ? Icons.assignment_turned_in
                        : Icons.assignment_turned_in,
                    color: Colors.white,
                    size: fet ? 30 : 20,
                  ),
                  Text(
                    "Fets",
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
    );

    FloatingActionButton floatingActionButton = FloatingActionButton(
      backgroundColor: Colors.orange[900],
      onPressed: () async {
        final Tasca result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateTasca(
              llistesUsuari: llistesUsuari,
              indexLlista: indexLlista,
            ),
          ),
        );

        if (result != null) {
          await DatabaseService().addTasca(result.toDBMap());
          print("Tasca afegida correctament!");
        }
      },
      tooltip: 'Afegir un nou element a la llista de tasques',
      child: Icon(Icons.add_box),
    );

    return Scaffold(
      extendBody: true,
      appBar: appBar,
      body: llista.isEmpty
          ? LlistaBuida(
              esTaronja: true,
            )
          : mostrarLlista,
      bottomNavigationBar: bottomAppBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatingActionButton,
      drawer: MyDrawer(
        canviarFinestra: canviarFinestra,
        actual: Finestra.Tasques,
      ),
    );
  }
}
