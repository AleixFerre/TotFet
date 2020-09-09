import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:compres/models/Usuari.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/shared/some_error_page.dart';
import 'package:compres/services/auth.dart';
import 'package:compres/wrapper.dart';

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 5,
          centerTitle: true,
        ),
        primaryColor: Colors.blue,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BuildApp(),
    );
  }
}

class BuildApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SomeErrorPage(
            error: snapshot.error.toString(),
          );
        }

        if (snapshot.hasData) {
          return StreamProvider<Usuari>.value(
            value: AuthService().userStream,
            child: Wrapper(),
          );
        }

        return Scaffold(
          body: Loading("Inicialitzant la aplicació de Firebase..."),
        );
      },
    );
  }
}
