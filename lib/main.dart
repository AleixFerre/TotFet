import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:llista_de_la_compra/pages/llista_compra.dart';
import 'package:llista_de_la_compra/pages/loading.dart';
import 'package:llista_de_la_compra/pages/some_error_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Llista de la compra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // SI HI HA HAGUT ALGUN ERROR
        if (snapshot.hasError) {
          return SomeErrorPage(
            snapshot: snapshot,
          );
        }

        // APP CARREGADA CORECTAMENT
        if (snapshot.connectionState == ConnectionState.done) {
          return CarregarBD();
        }

        // LOADING
        return Loading();
      },
    );
  }
}

class CarregarBD extends StatelessWidget {
  final Query productes = FirebaseFirestore.instance
      .collection('productes')
      .where("comprat", isEqualTo: false);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: productes.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // SI HI HA HAGUT ALGUN ERROR
          if (snapshot.hasError) {
            return SomeErrorPage(
              snapshot: snapshot,
            );
          }

          // APP CARREGADA CORECTAMENT
          if (snapshot.connectionState == ConnectionState.done) {
            List<Map<String, dynamic>> info = snapshot.data.docs.map((doc) {
              Map<String, dynamic> d = doc.data();
              d.putIfAbsent("key", () => doc.id);
              return d;
            }).toList();
            return LlistaCompra(llista: info);
          }

          // LOADING
          return Loading();
        });
  }
}
