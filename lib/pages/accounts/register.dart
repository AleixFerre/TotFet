import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:totfet/models/Finestra_auth.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/shared/loading.dart';

class Register extends StatefulWidget {
  final Function canviarFinestra;

  Register({this.canviarFinestra});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';
  String nomUsuari = '';

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Loading(
          msg: "Comprovant credencials...",
          esTaronja: false,
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 10,
          title: Text(
            "Registra't",
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
              icon: Icon(Icons.person, color: Colors.white),
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    SvgPicture.asset("images/register.svg", height: 200),
                    SizedBox(height: 20),
                    TextFormField(
                      // Email
                      decoration: InputDecoration(
                        labelText: "Nom d'usuari*",
                        hintText: "Introdueix el teu nom d'usuari",
                        helperText: "*Requerit",
                      ),
                      validator: (value) {
                        value = value.trim();
                        if (value == "") {
                          return "Has de tenir un nom.";
                        } else if (value.length > 15) {
                          return "El nom no pot tenir més de 15 lletres.";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          nomUsuari = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      // Email
                      decoration: InputDecoration(
                        labelText: 'Adreça electrònica*',
                        helperText: "*Requerit",
                      ),
                      validator: (val) => val.isEmpty
                          ? "Siusplau, entra un correu electrònic."
                          : null,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      // Password
                      decoration: InputDecoration(
                        labelText: 'Contrasenya*',
                        helperText: "*Requerit",
                      ),
                      validator: (val) => val.length < 6
                          ? "Siusplau, entra una contrasenya amb 6+ caràcters."
                          : null,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    SizedBox(height: 40),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      padding: EdgeInsets.all(8),
                      onPressed: () async {
                        setState(() => loading = true);
                        if (_formKey.currentState.validate()) {
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  email, password, nomUsuari);
                          if (result['response'] == null) {
                            setState(() => error = result['error']);
                          }
                        }
                        if (this.mounted) setState(() => loading = false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Registrar-se",
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
        ),
      );
    }
  }
}
