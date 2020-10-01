import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:totfet/models/Prioritat/Prioritat.dart';
import 'package:totfet/models/Tasca.dart';
import 'package:totfet/models/Usuari.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/services/auth.dart';

class CreateTasca extends StatefulWidget {
  final List<Map<String, String>> llistesUsuari;
  final int indexLlista;
  CreateTasca({this.llistesUsuari, this.indexLlista});

  @override
  _CreateTascaState createState() => _CreateTascaState();
}

class _CreateTascaState extends State<CreateTasca> {
  int indexLlista;

  @override
  void initState() {
    indexLlista = widget.indexLlista;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String llistaID = widget.llistesUsuari[indexLlista]['id'];

    void updateParent(int index) {
      if (index != indexLlista) {
        setState(() {
          indexLlista = index;
        });
      }
    }

    return FutureBuilder<QuerySnapshot>(
      future: DatabaseService().getUsuarisLlista(llistaID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SomeErrorPage(
            error: snapshot.error,
          );
        }

        if (snapshot.hasData) {
          return LlistarCompraCrear(
            llistesUsuari: widget.llistesUsuari,
            indexLlista: indexLlista,
            usuaris: snapshot.data.docs
                .map((e) => Usuari.fromDB(
                      e.id,
                      null,
                      e.data(),
                    ))
                .toList(),
            updateParent: updateParent,
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

class LlistarCompraCrear extends StatefulWidget {
  final List<Map<String, String>> llistesUsuari;
  final int indexLlista;
  final List<Usuari> usuaris;
  final Function updateParent;

  LlistarCompraCrear(
      {this.llistesUsuari, this.indexLlista, this.usuaris, this.updateParent});
  @override
  _LlistarCompraCrearState createState() => _LlistarCompraCrearState();
}

class _LlistarCompraCrearState extends State<LlistarCompraCrear> {
  Tasca tasca;
  int indexLlista;
  int indexUsuari;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tasca = Tasca.nova(null, AuthService().userId,
        widget.llistesUsuari[widget.indexLlista]['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Tasca"),
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
                      return "Siusplau, posa un nom";
                    } else if (value.length > 20) {
                      return "Nom massa llarg. (max. 20 caràcters)";
                    }
                    return null;
                  },
                  initialValue: tasca.nom,
                  onChanged: (str) {
                    setState(() {
                      tasca.nom = (str.trim() == "") ? null : str.trim();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Nom de la tasca*',
                    counterText: "${tasca.nom?.length ?? 0}/20",
                    helperText: "*Requerit",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 5,
                  validator: (value) {
                    value = value.trim();
                    if (value.length > 255) {
                      return "La descripció és massa llarga. (max. 255 caràcters)";
                    }
                    return null;
                  },
                  initialValue: tasca.descripcio,
                  onChanged: (str) {
                    setState(() {
                      tasca.descripcio = (str.trim() == "") ? null : str.trim();
                    });
                  },
                  decoration: InputDecoration(
                    counterText: "${tasca.descripcio?.length ?? 0}/255",
                    labelText: 'Descripció de la tasca',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Selecciona una llista"),
                    DropdownButton<String>(
                      hint: Text("Escolleix una llista"),
                      value: widget
                              .llistesUsuari[indexLlista ?? widget.indexLlista]
                          ['id'],
                      items: widget.llistesUsuari.map<DropdownMenuItem<String>>(
                        (Map<String, String> value) {
                          return DropdownMenuItem<String>(
                            value: value['id'],
                            child: Text(value['nom']),
                          );
                        },
                      ).toList(),
                      onChanged: (String newValue) {
                        indexLlista = widget.llistesUsuari.indexWhere(
                          (element) => element['id'] == newValue,
                        );
                        tasca.idAssignat = null;
                        widget.updateParent(indexLlista);
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
                    Text("Assigna un usuari de la llista"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          hint: Text("Selecciona un usuari"),
                          value: tasca.idAssignat,
                          items: widget.usuaris
                              .map<DropdownMenuItem<String>>((Usuari value) {
                            return DropdownMenuItem<String>(
                              value: value.uid,
                              child: Text(value.nom),
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              tasca.idAssignat = newValue;
                            });
                          },
                        ),
                        IconButton(
                          tooltip: "Desseleccionar assignat",
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              tasca.idAssignat = null;
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
                      value: tasca.prioritat,
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
                          tasca.prioritat = newValue;
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
                            tasca.dataPrevista == null
                                ? "Escolleix la data"
                                : tasca.dataPrevista
                                        .toDate()
                                        .day
                                        .toString()
                                        .padLeft(2, "0") +
                                    "/" +
                                    tasca.dataPrevista
                                        .toDate()
                                        .month
                                        .toString()
                                        .padLeft(2, "0") +
                                    "/" +
                                    tasca.dataPrevista.toDate().year.toString(),
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
                          initialDate: tasca.dataPrevista == null
                              ? DateTime.now()
                              : DateTime.fromMillisecondsSinceEpoch(
                                  tasca.dataPrevista.millisecondsSinceEpoch),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
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
                          if (picked == null) {
                            tasca.dataPrevista = null;
                          } else {
                            tasca.dataPrevista = Timestamp.fromDate(picked);
                          }
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
                            tasca.tempsEstimat == null
                                ? "Escolleix el temps estimat"
                                : tasca.tempsEstimat.toString() + "h",
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
                                title: Text("Temps estimat en hores"),
                                minValue: 1,
                                maxValue: 100,
                                initialIntegerValue: tasca.tempsEstimat ?? 1,
                              ),
                            );
                          },
                        );

                        setState(() {
                          tasca.tempsEstimat = picked;
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
                    Navigator.pop(context, tasca);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'Afegir',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.add_circle,
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
