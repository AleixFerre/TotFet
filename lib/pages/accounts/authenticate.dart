import 'package:flutter/material.dart';
import 'package:llista_de_la_compra/pages/accounts/register.dart';
import 'package:llista_de_la_compra/pages/accounts/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  // Toggle both views
  bool showSiginIn = true;
  void toggleView() {
    setState(() => showSiginIn = !showSiginIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSiginIn)
      return SignIn(toggleView: toggleView);
    else
      return Register(toggleView: toggleView);
  }
}
