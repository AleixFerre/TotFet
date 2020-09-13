import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:totfet/services/messaging.dart';
import 'package:totfet/models/Usuari.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/wrapper.dart';

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

    // Initialize Firebase Push Notifications Service
    MessagingService().initialize();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TotFet',
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
  Future initFirebase() async {
    // Initialize Firebase App
    await Firebase.initializeApp();
  }

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
          body: Loading(
            msg: "Inicialitzant la aplicació de Firebase...",
            esTaronja: false,
          ),
        );
      },
    );
  }
}
