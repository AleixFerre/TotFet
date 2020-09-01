import 'package:flutter/material.dart';
import 'package:llista_de_la_compra/models/Usuari.dart';
import 'package:llista_de_la_compra/pages/accounts/Authenticate.dart';
import 'package:llista_de_la_compra/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usuari>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return CarregarBD();
    }
  }
}
