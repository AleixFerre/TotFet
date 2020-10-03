import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totfet/models/Actualitzacio.dart';
import 'package:totfet/models/Ban.dart';
import 'package:totfet/models/Finestra.dart';
import 'package:totfet/pages/accounts/profile.dart';
import 'package:totfet/pages/menu_principal.dart';
import 'package:totfet/pages/tasques/carregar_BD_tasques.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/services/versionControl.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/ban_page.dart';
import 'package:totfet/shared/nova_actualitzacio.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/models/Usuari.dart';
import 'package:totfet/pages/accounts/Authenticate.dart';
import 'package:totfet/pages/compres/carregar_BD.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Finestra finestra = Finestra.Menu;

  void canviarFinestra(Finestra nova) {
    if (nova != finestra) {
      // Si cliquem el botó de la mateixa finestra,
      // No fem res (més optimitzat)
      setState(() {
        finestra = nova;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usuari>(context);

    if (user == null) {
      // Si no hi ha un usuari autentificat, mostra la pagina
      return Authenticate();
    } else {
      return comprovarBan();
    }
  }

  StreamBuilder<DocumentSnapshot> comprovarBan() {
    final Stream<DocumentSnapshot> banStream =
        DatabaseService(uid: AuthService().userId).getUserData();

    // Mostrar el que calgui després (app / banPage)
    return StreamBuilder(
      stream: banStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return SomeErrorPage(
            error:
                "Hi ha hagut un error al comprovar si l'usuari està banejat!\n" +
                    snapshot.error.toString(),
          );
        }

        if (snapshot.hasData) {
          final banData = snapshot.data.data()['ban'];
          if (banData != null) {
            Ban ban = Ban.fromDBMap(banData);
            return BanPage(ban: ban);
          }
          // Si no estem banejats, volem comprovar actualitzacions
          return comprovarActualitzacions();
        }
        return Scaffold(
          body: Loading(
            msg: "Comprovant detalls...",
            esTaronja: false,
          ),
        );
      },
    );
  }

  FutureBuilder<DocumentSnapshot> comprovarActualitzacions() {
    return FutureBuilder(
      future: DatabaseService().getCurrentVersion(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return SomeErrorPage(error: snapshot.error.toString());
        }

        if (snapshot.hasData) {
          Map data = VersionControlService().checkCurrentVersion(
            snapshot.data.data(),
          );
          if (data == null) {
            // No hi ha cap actualitzacio
            return mostrarApp();
          } else {
            // Tenim actualitzacions!
            return NovaActualitzacio(
              actualitzacio: Actualitzacio.fromData(data),
            );
          }
        }

        return Scaffold(
          body: Loading(
            msg: "Comprovant noves verions...",
            esTaronja: false,
          ),
        );
      },
    );
  }

  Widget mostrarApp() {
    // Si hi ha algun usuari dins, mirem la finestra que volem
    if (finestra == Finestra.Menu)
      return MenuPrincipal(canviarFinestra: canviarFinestra);
    else if (finestra == Finestra.Compres)
      return CarregarBD(canviarFinestra: canviarFinestra);
    else if (finestra == Finestra.Perfil)
      return Perfil(canviarFinestra: canviarFinestra);
    else if (finestra == Finestra.Tasques)
      return Tasques(canviarFinestra: canviarFinestra);
    else
      return SomeErrorPage(
        error:
            "No s'ha trobat la pàgina! Tanca la app DEL TOT i torna a entrar.",
      );
  }
}
