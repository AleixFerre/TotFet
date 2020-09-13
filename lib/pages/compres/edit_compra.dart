import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:totfet/models/Usuari.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/models/Prioritat/Prioritat.dart';
import 'package:totfet/models/Tipus/Tipus.dart';

import 'package:numberpicker/numberpicker.dart';

class EditCompra extends StatelessWidget {
  final Map compra;
  EditCompra({this.compra});

  @override
  Widget build(BuildContext context) {
    String idLlista = compra['idLlista'];

    return FutureBuilder<QuerySnapshot>(
      future: DatabaseService().getUsuarisLlista(idLlista),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SomeErrorPage(
            error: snapshot.error,
          );
        }

        if (snapshot.hasData) {
          return LlistarCompraEdit(
            compra: compra,
            usuaris: snapshot.data.docs
                .map((e) => Usuari.fromDB(
                      e.id,
                      null,
                      e.data(),
                    ))
                .toList(),
          );
        }

        return Scaffold(
          body: Loading(
            msg: "Carregant usuaris de la llista...",
            esTaronja: false,
          ),
        );
      },
    );
  }
}

class LlistarCompraEdit extends StatefulWidget {
  final Map compra;
  final List<Usuari> usuaris;
  LlistarCompraEdit({this.compra, this.usuaris});

  @override
  _LlistarCompraEditState createState() => _LlistarCompraEditState();
}

class _LlistarCompraEditState extends State<LlistarCompraEdit> {
  Map<String, dynamic> model;

  final _formKey = GlobalKey<FormState>();

  String readTimestamp(Timestamp timestamp) {
    DateTime date =
        DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);

    String str = date.day.toString().padLeft(2, "0") +
        "/" +
        date.month.toString().padLeft(2, "0") +
        "/" +
        date.year.toString();

    return str;
  }

  @override
  void initState() {
    model = widget.compra;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Compra"),
        centerTitle: true,
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
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: TextFormField(
                  validator: (value) {
                    value = value.trim();
                    if (value == "") {
                      return "Siusplau, posa un nom a la compra.";
                    }
                    return null;
                  },
                  initialValue: model['nom'],
                  onChanged: (str) {
                    setState(() {
                      model['nom'] = (str.trim() == "") ? null : str.trim();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Entra el nom del producte...',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Selecciona un usuari de la llista"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          hint: Text("Assigna un usuari"),
                          value: model['idAssignat'],
                          items: widget.usuaris
                              .map<DropdownMenuItem<String>>((Usuari value) {
                            return DropdownMenuItem<String>(
                              value: value.uid,
                              child: Text(value.nom),
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              model['idAssignat'] = newValue;
                            });
                          },
                        ),
                        IconButton(
                          tooltip: "Desseleccionar assignat",
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              model['idAssignat'] = null;
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Quantitat: ${model['quantitat'].toInt()}"),
                    Slider(
                      value: model['quantitat'].toDouble(),
                      min: 1,
                      max: 30,
                      divisions: 29,
                      label: "${model['quantitat'].toInt()}",
                      onChanged: (value) {
                        setState(() {
                          model['quantitat'] = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Selecciona un tipus de producte"),
                    DropdownButton<String>(
                      hint: Text("Escolleix un tipus"),
                      value: model['tipus'],
                      items: Tipus.values
                          .map<DropdownMenuItem<String>>((Tipus value) {
                        return DropdownMenuItem<String>(
                          value: value
                              .toString()
                              .substring(value.toString().indexOf('.') + 1),
                          child: Text(value
                              .toString()
                              .substring(value.toString().indexOf('.') + 1)),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          model['tipus'] = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Selecciona una prioritat"),
                    DropdownButton<String>(
                      hint: Text("Escolleix una prioritat"),
                      value: model['prioritat'],
                      items: Prioritat.values
                          .map<DropdownMenuItem<String>>((Prioritat value) {
                        return DropdownMenuItem<String>(
                          value: value
                              .toString()
                              .substring(value.toString().indexOf('.') + 1),
                          child: Text(value
                              .toString()
                              .substring(value.toString().indexOf('.') + 1)),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          model['prioritat'] = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Selecciona una data prevista de compra"),
                    RaisedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model['dataPrevista'] == null
                                ? "Escolleix la data"
                                : readTimestamp(model['dataPrevista']),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: model['dataPrevista'] == null
                              ? DateTime.now()
                              : DateTime.fromMicrosecondsSinceEpoch(
                                  model['dataPrevista'].microsecondsSinceEpoch),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        setState(() {
                          model['dataPrevista'] = picked == null
                              ? null
                              : Timestamp.fromDate(picked);
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Selecciona un preu estimat"),
                    RaisedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model['preuEstimat'] == null
                                ? "Escolleix el preu estimat"
                                : model['preuEstimat'].toString() + "€",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.euro),
                        ],
                      ),
                      onPressed: () async {
                        final picked = await showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return new NumberPickerDialog.integer(
                              title: Text("Preu estimat en €"),
                              minValue: 1,
                              maxValue: 100,
                              initialIntegerValue: model['preuEstimat'] ?? 1,
                            );
                          },
                        );

                        setState(() {
                          model['preuEstimat'] = picked;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.pop(context, model);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'Editar',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.edit,
                      size: 40,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
