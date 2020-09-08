import 'package:compres/models/Finestra.dart';
import 'package:compres/pages/menu_principal.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/shared/some_error_page.dart';
import 'package:flutter/material.dart';
import 'package:compres/models/Usuari.dart';
import 'package:compres/pages/accounts/Authenticate.dart';
import 'package:compres/pages/compres/carregar_BD.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Finestra finestra = Finestra.Menu;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usuari>(context);

    if (user == null) {
      return Authenticate();
    } else {
      if (finestra == Finestra.Menu)
        return MenuPrincipal();
      else if (finestra == Finestra.Llista)
        return CarregarBD();
      else if (finestra == Finestra.Tasques)
        return Loading("Tasques encara està per fer..."); //Tasques();
      else
        return SomeErrorPage(error: "No s'ha trobat la pàgina!");
    }
  }
}
