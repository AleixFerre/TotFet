import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/models/Usuari.dart';
import 'package:compres/services/database.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/shared/some_error_page.dart';
import 'package:flutter/material.dart';

import 'package:compres/models/Prioritat/Prioritat.dart';
import 'package:compres/models/Tipus/Tipus.dart';

import 'package:numberpicker/numberpicker.dart';

class EditTasca extends StatelessWidget {
  final Map tasca;
  EditTasca({this.tasca});

  @override
  Widget build(BuildContext context) {
    String idLlista = tasca['idLlista'];

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
            tasca: tasca,
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
          body: Loading("Carregant usuaris de la llista..."),
        );
      },
    );
  }
}

class LlistarCompraEdit extends StatefulWidget {
  final Map tasca;
  final List<Usuari> usuaris;
  LlistarCompraEdit({this.tasca, this.usuaris});

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
    model = widget.tasca;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Tasca"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.orange[400],
                Colors.deepOrange[900],
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
                      return "Siusplau, posa un nom a la tasca.";
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
                    labelText: 'Entra el nom de la tasca...',
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
                    Text("Selecciona una data prevista de tasca"),
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
                    Text("Selecciona un temps estimat"),
                    RaisedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model['tempsEstimat'] == null
                                ? "Escolleix el temps estimat"
                                : model['tempsEstimat'].toString() + "h",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.schedule),
                        ],
                      ),
                      onPressed: () async {
                        final picked = await showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return new NumberPickerDialog.integer(
                              title: Text("Temps estimat en h"),
                              minValue: 1,
                              maxValue: 100,
                              initialIntegerValue: model['tempsEstimat'] ?? 1,
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
                color: Colors.deepOrange[400],
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
