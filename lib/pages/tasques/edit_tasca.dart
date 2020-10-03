import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:totfet/models/Duracio.dart';
import 'package:totfet/models/Tasca.dart';

import 'package:totfet/models/Usuari.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/models/Prioritat.dart';

class EditTasca extends StatelessWidget {
  final Tasca tasca;
  EditTasca({this.tasca});

  @override
  Widget build(BuildContext context) {
    String idLlista = tasca.idLlista;

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
          body: Loading(
            msg: "Carregant usuaris de la llista...",
            esTaronja: true,
          ),
        );
      },
    );
  }
}

class LlistarCompraEdit extends StatefulWidget {
  final Tasca tasca;
  final List<Usuari> usuaris;
  LlistarCompraEdit({this.tasca, this.usuaris});

  @override
  _LlistarCompraEditState createState() => _LlistarCompraEditState();
}

class _LlistarCompraEditState extends State<LlistarCompraEdit> {
  Tasca model;

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
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    value = value.trim();
                    if (value == "") {
                      return "Siusplau, posa un nom a la tasca.";
                    } else if (value.length > 30) {
                      return "El nom de la tasca és massa llarg. (max. 30 caràcters)";
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
                    labelText: 'Nom de la tasca*',
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
                  minLines: 1,
                  maxLines: 5,
                  validator: (value) {
                    value = value.trim();
                    if (value.length > 255) {
                      return "La descripció és massa llarga. (max. 255 caràcters)";
                    }
                    return null;
                  },
                  initialValue: model.descripcio,
                  onChanged: (str) {
                    setState(() {
                      model.descripcio = (str.trim() == "") ? null : str.trim();
                    });
                  },
                  decoration: InputDecoration(
                    counterText: "${model.descripcio?.length ?? 0}/255",
                    labelText: 'Descripció de la tasca',
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
                    Text("Selecciona una data prevista de tasca"),
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
                          initialDate: model.dataPrevista == null
                              ? DateTime.now()
                              : DateTime.fromMicrosecondsSinceEpoch(
                                  model.dataPrevista.microsecondsSinceEpoch),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          confirmText: "CONFIRMAR",
                          cancelText: "CANCEL·LAR",
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: Colors.orange[900],
                                  onPrimary: Colors.white,
                                  surface: Colors.orange,
                                  onSurface: Colors.black87,
                                ),
                                dialogBackgroundColor: Colors.orange[50],
                              ),
                              child: child,
                            );
                          },
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
                    Text("Selecciona una durada estimada"),
                    RaisedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model.tempsEstimat == null ||
                                    model.tempsEstimat.esZero()
                                ? "Escolleix la durada estimada"
                                : model.tempsEstimat.toString(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.schedule),
                        ],
                      ),
                      onPressed: () async {
                        Duracio duracio = Duracio();
                        duracio.hores = await showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                accentColor: Colors.orange[900],
                              ),
                              child: NumberPickerDialog.integer(
                                confirmWidget: Text(
                                  "CONFIRMAR",
                                  style: TextStyle(color: Colors.orange),
                                ),
                                cancelWidget: Text(
                                  "CANCEL·LAR",
                                  style: TextStyle(color: Colors.orange),
                                ),
                                title: Text("Hores estimades"),
                                minValue: 0,
                                maxValue: 24,
                                initialIntegerValue: model.tempsEstimat == null
                                    ? 1
                                    : model.tempsEstimat.hores,
                              ),
                            );
                          },
                        );
                        if (duracio.hores == null) {
                          setState(() {
                            model.tempsEstimat = null;
                          });
                          return;
                        } else {
                          duracio.minuts = await showDialog<int>(
                            context: context,
                            builder: (BuildContext context) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  accentColor: Colors.orange[900],
                                ),
                                child: NumberPickerDialog.integer(
                                  confirmWidget: Text(
                                    "CONFIRMAR",
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  cancelWidget: Text(
                                    "CANCEL·LAR",
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  title: Text("Minuts estimats"),
                                  minValue: 0,
                                  maxValue: 60,
                                  initialIntegerValue:
                                      model.tempsEstimat == null
                                          ? 1
                                          : model.tempsEstimat.minuts,
                                ),
                              );
                            },
                          );
                        }

                        setState(() {
                          if (duracio.minuts == null)
                            duracio = null;
                          else if (duracio.esZero()) duracio = null;
                          model.tempsEstimat = duracio;
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
                color: Colors.orange[400],
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
