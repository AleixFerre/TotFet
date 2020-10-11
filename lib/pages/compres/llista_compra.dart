import 'package:flutter/material.dart';
import 'package:totfet/models/Llista.dart';
import 'package:totfet/pages/llistes/administracio/detalls_llista.dart';

import 'package:totfet/shared/drawer.dart';
import 'package:totfet/models/Finestra.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/llista_buida.dart';
import 'package:totfet/models/Compra.dart';
import 'package:totfet/pages/compres/create_compra.dart';
import 'package:totfet/pages/compres/compra_card.dart';

class LlistaCompra extends StatelessWidget {
  LlistaCompra({
    // llista actual a mostrar
    this.llista,
    // llista de les llistes disponibles pel perfil actual
    this.llistesUsuari,
    // index de la llista actual
    this.indexLlista,
    // Funcio per canviar el valor de l'index de la llista del parent
    this.rebuildParentFiltre,
    // Funcio per canviar el valor Bool de comprat del parent
    this.rebuildParentComprat,
    // Bool per si s'esta mostrant les elements comprats o no
    this.comprat,
    // Funció a passar al drawer per poder canviar d'escenes
    this.canviarFinestra,
  });

  final List<Compra> llista;
  final List<Llista> llistesUsuari;
  final int indexLlista;
  final Function rebuildParentComprat;
  final Function rebuildParentFiltre;
  final bool comprat;
  final Function canviarFinestra;

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      elevation: 10,
      title: Text(
        "Compres de ${llistesUsuari[indexLlista].nom}",
        overflow: TextOverflow.fade,
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.blue[400],
              Colors.blue[900],
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            Llista infoLlista = llistesUsuari[indexLlista];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LlistaDetalls(
                  llista: infoLlista,
                  finestra: Finestra.Compres,
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
                  (Llista llista) => PopupMenuItem(
                    value: llistesUsuari.indexOf(llista),
                    child: Text(llista.nom),
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
        final Compra compra = llista[index];

        return comprat
            ? CompraCard(
                compra: compra,
                tipus: llistesUsuari,
              )
            : Dismissible(
                key: Key("${compra.id}"),
                background: Container(
                  color: Colors.green,
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                onDismissed: (direction) async {
                  await DatabaseService().comprarCompra(compra.id);
                  print("Compra realitzada correctament!");
                },
                child: CompraCard(
                  compra: compra,
                  tipus: llistesUsuari,
                ),
              );
      },
    );

    BottomAppBar bottomAppBar = BottomAppBar(
      elevation: 10,
      shape: CircularNotchedRectangle(),
      color: Colors.blue[800],
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
                rebuildParentComprat(false);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    !comprat ? Icons.shop_two : Icons.shop_two_outlined,
                    color: Colors.white,
                    size: !comprat ? 30 : 20,
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
                rebuildParentComprat(true);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    comprat
                        ? Icons.monetization_on
                        : Icons.monetization_on_outlined,
                    color: Colors.white,
                    size: comprat ? 30 : 20,
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
    );

    FloatingActionButton floatingActionButton = FloatingActionButton(
      backgroundColor: Colors.blue[700],
      onPressed: () async {
        final Compra result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateCompra(
              llistesUsuari: llistesUsuari,
              indexLlista: indexLlista,
            ),
          ),
        );

        if (result != null) {
          await DatabaseService().addCompra(result.toDBMap());
          print("Producte afegit correctament!");
        }
      },
      tooltip: 'Afegir un nou element a la llista de la compra',
      child: Icon(Icons.add_shopping_cart),
    );

    return Scaffold(
      extendBody: true,
      appBar: appBar,
      body: llista.isEmpty
          ? LlistaBuida(
              esTaronja: false,
            )
          : mostrarLlista,
      bottomNavigationBar: bottomAppBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatingActionButton,
      drawer: MyDrawer(
        canviarFinestra: canviarFinestra,
        actual: Finestra.Compres,
      ),
    );
  }
}
