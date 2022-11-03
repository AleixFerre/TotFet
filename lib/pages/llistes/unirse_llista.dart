import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:totfet/models/Finestra.dart';

import 'package:totfet/services/database.dart';
import 'package:totfet/shared/loading.dart';

class UnirseLlista extends StatefulWidget {
  final Finestra finestra;
  UnirseLlista({@required this.finestra});
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
      _textController.text = id.substring(0, min(id.length, 20));
      await comprovarLlista();
    } catch (e) {
      setState(() => errorMsg = e.toString());
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
        title: Text("Unir-se a una llista"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.finestra == Finestra.Tasques
                  ? <Color>[
                      Colors.orange[400],
                      Colors.deepOrange[900],
                    ]
                  : <Color>[
                      Colors.blue[400],
                      Colors.blue[900],
                    ],
            ),
          ),
        ),
      ),
      body: loading
          ? Loading(
              msg: "Comprovant la ID...",
              esTaronja: false,
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: scan,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Colors.white,
                        elevation: 5,
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
                                Icons.qr_code_scanner,
                                size: 50,
                              ),
                            ],
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
                        textCapitalization: TextCapitalization.sentences,
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
                        maxLength: 20,
                        decoration: InputDecoration(
                          counterText: "${id?.length ?? 0}/20",
                          labelText: 'ID de la Llista*',
                          helperText: "*Requerit",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      color: widget.finestra == Finestra.Tasques
                          ? Colors.orange[400]
                          : Colors.blueAccent,
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
