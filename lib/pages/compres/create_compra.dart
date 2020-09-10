import 'package:compres/models/Usuari.dart';
import 'package:compres/services/database.dart';
import 'package:compres/shared/loading.dart';
import 'package:compres/shared/some_error_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:compres/models/Compra.dart';
import 'package:compres/models/Prioritat/Prioritat.dart';
import 'package:compres/models/Tipus/Tipus.dart';
import 'package:compres/services/auth.dart';

import 'package:numberpicker/numberpicker.dart';

class CreateCompra extends StatefulWidget {
  final List<Map<String, String>> llistesUsuari;
  final int indexLlista;
  CreateCompra({this.llistesUsuari, this.indexLlista});

  @override
  _CreateCompraState createState() => _CreateCompraState();
}

class _CreateCompraState extends State<CreateCompra> {
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
          body: Loading("Carregant usuaris de la llista..."),
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
  Compra compra;
  int indexLlista;
  int indexUsuari;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print("init state");
    super.initState();
    compra = Compra.nova(null, AuthService().userId,
        widget.llistesUsuari[widget.indexLlista]['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Compra"),
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
                      return "Siusplau, posa un nom";
                    }
                    return null;
                  },
                  initialValue: compra.nom,
                  onChanged: (str) {
                    setState(() {
                      compra.nom = (str.trim() == "") ? null : str.trim();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Entra el nom del producte',
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
                        compra.idAssignat = null;
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
                    Text("Selecciona un usuari de la llista"),
                    DropdownButton<String>(
                      hint: Text("Assigna un usuari"),
                      value: compra.idAssignat,
                      items: widget.usuaris
                          .map<DropdownMenuItem<String>>((Usuari value) {
                        return DropdownMenuItem<String>(
                          value: value.uid,
                          child: Text(value.nom),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          compra.idAssignat = newValue;
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
                    Text("Quantitat: ${compra.quantitat}"),
                    Slider(
                      value: compra.quantitat.toDouble(),
                      min: 1,
                      max: 30,
                      divisions: 29,
                      label: "${compra.quantitat}",
                      onChanged: (value) {
                        setState(() {
                          compra.quantitat = value.toInt();
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
                      value: compra.tipus,
                      items: Tipus.values
                          .map<DropdownMenuItem<Tipus>>((Tipus value) {
                        return DropdownMenuItem<Tipus>(
                          value: value,
                          child: Text(value
                              .toString()
                              .substring(value.toString().indexOf('.') + 1)),
                        );
                      }).toList(),
                      onChanged: (Tipus newValue) {
                        setState(() {
                          compra.tipus = newValue;
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
                      value: compra.prioritat,
                      items: Prioritat.values
                          .map<DropdownMenuItem<Prioritat>>((Prioritat value) {
                        return DropdownMenuItem<Prioritat>(
                          value: value,
                          child: Text(value
                              .toString()
                              .substring(value.toString().indexOf('.') + 1)),
                        );
                      }).toList(),
                      onChanged: (Prioritat newValue) {
                        setState(() {
                          compra.prioritat = newValue;
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
                            compra.dataPrevista == null
                                ? "Escolleix la data"
                                : compra.dataPrevista
                                        .toDate()
                                        .day
                                        .toString()
                                        .padLeft(2, "0") +
                                    "/" +
                                    compra.dataPrevista
                                        .toDate()
                                        .month
                                        .toString()
                                        .padLeft(2, "0") +
                                    "/" +
                                    compra.dataPrevista
                                        .toDate()
                                        .year
                                        .toString(),
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
                          initialDate: compra.dataPrevista == null
                              ? DateTime.now()
                              : DateTime.fromMillisecondsSinceEpoch(
                                  compra.dataPrevista.millisecondsSinceEpoch),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        setState(() {
                          if (picked == null) {
                            compra.dataPrevista = null;
                          } else {
                            compra.dataPrevista = Timestamp.fromDate(picked);
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
                    Text("Selecciona un preu estimat"),
                    RaisedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            compra.preuEstimat == null
                                ? "Escolleix el preu estimat"
                                : compra.preuEstimat.toString() + "€",
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
                              initialIntegerValue: compra.preuEstimat ?? 1,
                            );
                          },
                        );

                        setState(() {
                          compra.preuEstimat = picked;
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
                    Navigator.pop(context, compra);
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
