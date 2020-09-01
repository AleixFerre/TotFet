import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:llista_de_la_compra/models/Usuari.dart';
import 'package:llista_de_la_compra/shared/loading.dart';
import 'package:llista_de_la_compra/shared/some_error_page.dart';
import 'package:llista_de_la_compra/services/auth.dart';
import 'package:llista_de_la_compra/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lock the orientation to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Compres',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SomeErrorPage(
              error: snapshot.error.toString(),
            );
          }

          if (snapshot.hasData) {
            return StreamProvider<Usuari>.value(
              value: AuthService().user,
              child: Wrapper(),
            );
          }

          return Loading("Inicialitzant la aplicació de Firebase...");
        },
      ),
    );
  }
}
