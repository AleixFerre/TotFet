import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:compres/services/auth.dart';
import 'package:compres/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

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
    return loading
        ? Scaffold(
            body: Loading("Comprovant credencials..."),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0,
              title: Text("Registra't"),
              actions: [
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person),
                  label: Text("Inicia la sessió"),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 50,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        // Email
                        decoration: InputDecoration(
                          labelText: "Nom d'usuari.",
                          hintText: "Introdueix el teu nom d'usuari",
                        ),
                        validator: (value) {
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
                          hintText: "Adreça electrònica / email",
                          labelText: 'Introdueix la teva adreça electrònica...',
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
                          labelText: 'Contrasenya',
                          hintText: "Introdueix la contrasenya...",
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
                      SizedBox(height: 20),
                      RaisedButton(
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
                        color: Colors.pink[400],
                        child: Text(
                          "Registrar-se",
                          style: TextStyle(color: Colors.white),
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
