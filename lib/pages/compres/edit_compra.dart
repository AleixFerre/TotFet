import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totfet/models/Compra.dart';

import 'package:totfet/models/Usuari.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/models/Prioritat.dart';
import 'package:totfet/models/Tipus.dart';

import 'package:numberpicker/numberpicker.dart';

class EditCompra extends StatelessWidget {
  final Compra compra;
  EditCompra({this.compra});

  @override
  Widget build(BuildContext context) {
    String idLlista = compra.idLlista;

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
  final Compra compra;
  final List<Usuari> usuaris;
  LlistarCompraEdit({this.compra, this.usuaris});

  @override
  _LlistarCompraEditState createState() => _LlistarCompraEditState();
}

class _LlistarCompraEditState extends State<LlistarCompraEdit> {
  Compra model;

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
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    value = value.trim();
                    if (value == "") {
                      return "Siusplau, posa un nom a la compra.";
                    } else if (value.length > 30) {
                      return "El nom de la compra és massa llarg. (max. 30 caràcters)";
                    }
                    return null;
                  },
                  initialValue: model.nom,
                  onChanged: (str) {
                    setState(() {
                      model.nom = (str.trim() == "") ? null : str.trim();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Nom del producte*',
                    counterText: "${model.nom?.length ?? 0}/30",
                    helperText: "*Requerit",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  initialValue: model.descripcio,
                 
                  validator: (value) {
                    value = value.trim();
                    if (value.length > 255) {
                      return "Descripció massa llarga (max. 255 caràcters)";
                    }
                    return null;
                  },
                  onChanged: (str) {
                    setState(() {
                      model.descripcio = (str.trim() == "") ? null : str.trim();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Descripció del producte',
                    counterText: "${model.descripcio?.length ?? 0}/255",
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
                          value: model.idAssignat,
                          items: widget.usuaris
                              .map<DropdownMenuItem<String>>((Usuari value) {
                            return DropdownMenuItem<String>(
                              value: value.uid,
                              child: Text(value.nom),
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              model.idAssignat = newValue;
                            });
                          },
                        ),
                        IconButton(
                          tooltip: "Desseleccionar assignat",
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              model.idAssignat = null;
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
                    Text("Quantitat: ${model.quantitat.toInt()}"),
                    Slider(
                      value: model.quantitat.toDouble(),
                      min: 1,
                      max: 30,
                      divisions: 29,
                      label: "${model.quantitat.toInt()}",
                      onChanged: (value) {
                        setState(() {
                          model.quantitat = value.toInt();
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
                    DropdownButton<Tipus>(
                      hint: Text("Escolleix un tipus"),
                      value: model.tipus,
                      items: Tipus.values
                          .map<DropdownMenuItem<Tipus>>((Tipus value) {
                        return DropdownMenuItem<Tipus>(
                          value: value,
                          child: Row(
                            children: [
                              tipustoIcon(value),
                              SizedBox(
                                width: 10,
                              ),
                              Text(tipusToString(value)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (Tipus newValue) {
                        setState(() {
                          model.tipus = newValue;
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
                    DropdownButton<Prioritat>(
                      hint: Text("Escolleix una prioritat"),
                      value: model.prioritat,
                      items: Prioritat.values
                          .map<DropdownMenuItem<Prioritat>>((Prioritat value) {
                        return DropdownMenuItem<Prioritat>(
                          value: value,
                          child: Row(
                            children: [
                              prioritatIcon(value),
                              SizedBox(
                                width: 10,
                              ),
                              Text(prioritatToString(value)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (Prioritat newValue) {
                        setState(() {
                          model.prioritat = newValue;
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
                            model.dataPrevista == null
                                ? "Escolleix la data"
                                : readTimestamp(model.dataPrevista),
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
                          helpText: "SELECCIONA UNA DATA",
                          confirmText: "CONFIRMAR",
                          cancelText: "CANCEL·LAR",
                          initialDate: model.dataPrevista == null
                              ? DateTime.now()
                              : DateTime.fromMicrosecondsSinceEpoch(
                                  model.dataPrevista.microsecondsSinceEpoch),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        setState(() {
                          model.dataPrevista = picked == null
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
                            model.preuEstimat == null
                                ? "Escolleix el preu estimat"
                                : model.preuEstimat.toString() + "€",
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
                              initialIntegerValue: model.preuEstimat ?? 1,
                            );
                          },
                        );

                        setState(() {
                          model.preuEstimat = picked;
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
                    Navigator.pop(context, model.toDBMap());
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
