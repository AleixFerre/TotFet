import 'package:compres/pages/accounts/welcome.dart';
import 'package:flutter/material.dart';
import 'package:compres/pages/accounts/register.dart';
import 'package:compres/pages/accounts/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  // Toggle both views
  bool showSiginIn = true;
  bool showWelcome = true;
  void toggleView() {
    setState(() => showSiginIn = !showSiginIn);
  }

  void setWelcome(bool signinIn) {
    setState(() {
      showWelcome = false;
      showSiginIn = signinIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showWelcome)
      return Welcome(setWelcome: setWelcome);
    else if (showSiginIn)
      return SignIn(toggleView: toggleView);
    else
      return Register(toggleView: toggleView);
  }
}
