import 'package:flutter/material.dart';
import 'package:totfet/models/Finestra_auth.dart';
import 'package:totfet/pages/accounts/forgot_password.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/pages/accounts/welcome.dart';
import 'package:totfet/pages/accounts/register.dart';
import 'package:totfet/pages/accounts/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  // Toggle both views
  FinestraAuth finestra = FinestraAuth.Welcome;

  void canviarFinestra(FinestraAuth nova) {
    setState(() => finestra = nova);
  }

  @override
  Widget build(BuildContext context) {
    if (finestra == FinestraAuth.Welcome)
      return Welcome(canviarFinestra: canviarFinestra);
    else if (finestra == FinestraAuth.SignIn)
      return SignIn(canviarFinestra: canviarFinestra);
    else if (finestra == FinestraAuth.Register)
      return Register(canviarFinestra: canviarFinestra);
    else if (finestra == FinestraAuth.ForgotPassword)
      return ForgotPassword(canviarFinestra: canviarFinestra);
    else
      return SomeErrorPage(error: "No s'ha trobat cap pagina...");
  }
}
