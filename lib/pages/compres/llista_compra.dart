import 'dart:ui';

import 'package:compres/shared/sortir_sessio.dart';
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
  });

  final List<Map<String, dynamic>> llista;
  final List<Map<String, String>> llistesUsuari;
  final int indexLlista;
  final Function rebuildParentComprat;
  final Function rebuildParentFiltre;
  final bool comprat;

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      leading: PopupMenuButton<int>(
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
                  child: Text(llista['nom'] + " - " + llista['id']),
                ),
              )
              .toList();
        },
      ),
      title: Center(
        child: Text("Compres de ${llistesUsuari[indexLlista]['nom']}"),
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
        SortirSessio(),
      ],
    );

    Column llistaBuida = Column(
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
    );

    ListView mostrarLlista = ListView.builder(
      itemCount: llista.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> compra = llista[index];
        final compraKey = compra['key'];
        final Icon tipusIcon = TipusEmojis(tipus: compra['tipus']).toIcon();
        final Color cardColor =
            PrioritatColor(prioritat: compra['prioritat']).toColor();
        final String prioritatString =
            PrioritatColor(prioritat: compra['prioritat']).toString();

        return comprat
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
                  DocumentReference document = FirebaseFirestore.instance
                      .collection('compres')
                      .doc(compraKey);
                  await document.update({
                    "comprat": true,
                    "idComprador": AuthService().userId,
                    "dataCompra": Timestamp.now(),
                  });
                  /*
                  final SnackBar snackBar = SnackBar(
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
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                  */
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
    );

    BottomAppBar bottomAppBar = BottomAppBar(
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
      onPressed: () async {
        final Compra result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreateCompra()));

        CollectionReference compres =
            FirebaseFirestore.instance.collection('compres');

        if (result != null) {
          await compres
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
    );

    return Scaffold(
      extendBody: true,
      appBar: appBar,
      body: llista.isEmpty ? llistaBuida : mostrarLlista,
      bottomNavigationBar: bottomAppBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatingActionButton,
    );
  }
}
