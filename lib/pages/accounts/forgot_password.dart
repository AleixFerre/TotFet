import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:totfet/models/Finestra_auth.dart';
import 'package:totfet/services/auth.dart';

class ForgotPassword extends StatefulWidget {
  final Function canviarFinestra;

  ForgotPassword({this.canviarFinestra});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    GlobalKey scaffoldKey = GlobalKey();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 10,
        title: Text(
          "Recuperar contrasenya",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.blue[400],
                Colors.blue[900],
              ],
            ),
          ),
        ),
        actions: [
          FlatButton.icon(
            onPressed: () {
              widget.canviarFinestra(FinestraAuth.SignIn);
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text(
              "Inicia la sessió",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                SvgPicture.asset(
                  "images/forgot.svg",
                  height: 200,
                ),
                SizedBox(height: 20),
                TextFormField(
                  // Email
                  decoration: InputDecoration(
                    hintText: "Adreça electrònica",
                  ),
                  validator: (val) => val.isEmpty
                      ? "Siusplau, entra un correu electrònic."
                      : null,
                  onChanged: (value) {
                    setState(() => email = value);
                  },
                ),
                SizedBox(height: 40),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding: EdgeInsets.all(8),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      error = await _auth.sendPasswordResetEmail(email) ?? "";

                      if (error != null) {
                        return setState(() {});
                      }

                      // Surt l'alerta de mirar el correu
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Mira el teu correu!'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                    "Allà t'hem enviat un correu de recuperació.",
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "D'acord",
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      widget.canviarFinestra(FinestraAuth.SignIn);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 20,
                    ),
                    child: Text(
                      "Envia",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
