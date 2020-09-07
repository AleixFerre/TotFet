import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:compres/services/database.dart';
import 'package:compres/shared/loading.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class UnirseLlista extends StatefulWidget {
  @override
  _UnirseLlistaState createState() => _UnirseLlistaState();
}

class _UnirseLlistaState extends State<UnirseLlista> {
  final _formKey = GlobalKey<FormState>();
  String id = "";
  bool loading = false;
  String errorMsg = "";
  TextEditingController _textController;

  Future scan() async {
    try {
      id = await scanner.scan() ?? "";
      _textController.text = id;
      await comprovarLlista();
    } catch (e) {
      setState(() => errorMsg = 'Unknown error: $e');
    }
  }

  Future comprovarLlista() async {
    setState(() {
      loading = true;
    });
    bool mostrarError = true;
    if (_formKey.currentState.validate()) {
      // Comprovo si existeix la llista com a tal
      if (await DatabaseService().existeixLlista(id)) {
        // Comprovo si no estic ja a dins
        if (await DatabaseService().pucEntrarLlista(id)) {
          mostrarError = false;
          Navigator.pop(context, id);
        }
        if (mostrarError) {
          setState(() {
            errorMsg = "Ja estas dins d'aquesta llista";
          });
        }
      } else {
        setState(() {
          errorMsg = "No existeix cap llista amb aquest ID";
        });
      }
    }
    if (this.mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _textController = TextEditingController(text: id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Unir-se a una llista"),
        ),
      ),
      body: loading
          ? Loading("Comprovant la ID...")
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: RaisedButton(
                          onPressed: scan,
                          color: Colors.blue[100],
                          child: SizedBox(
                            width: 350,
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Escanejar Codi QR",
                                  style: TextStyle(fontSize: 30),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.qr_code,
                                  size: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Text("O bé posa el codi manualment:"),
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.topCenter,
                      child: TextFormField(
                        controller: _textController,
                        validator: (value) {
                          if (value.length != 20) {
                            return "La ID ha de tenir 20 caràcters.";
                          }
                          return null;
                        },
                        onChanged: (str) {
                          setState(() {
                            id = str;
                          });
                        },
                        decoration: InputDecoration(
                          counterText: "${id.length}/20",
                          labelText: 'Entra la ID de la llista',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.blueAccent,
                      onPressed: () async {
                        comprovarLlista();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'Unir-me',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.group_add,
                            size: 40,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (errorMsg == "") ? "" : "Error: $errorMsg.",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
