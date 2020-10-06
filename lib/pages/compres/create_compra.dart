import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:totfet/models/Llista.dart';

import 'package:totfet/models/Usuari.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';
import 'package:totfet/models/Compra.dart';
import 'package:totfet/models/Prioritat.dart';
import 'package:totfet/models/Tipus.dart';
import 'package:totfet/services/auth.dart';

class CreateCompra extends StatefulWidget {
  final List<Llista> llistesUsuari;
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
    String llistaID = widget.llistesUsuari[indexLlista].id;

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
            esTaronja: false,
          ),
        );
      },
    );
  }
}

class LlistarCompraCrear extends StatefulWidget {
  final List<Llista> llistesUsuari;
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
    super.initState();
    compra = Compra.nova(null, AuthService().userId,
        widget.llistesUsuari[widget.indexLlista].id);
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
      body: WillPopScope(
        onWillPop: () async => compra.nom == null || compra.nom == ""
            ? true
            : showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Tens canvis sense guardar!"),
                  content: Text("Vols sortir sense guardar?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel·lar"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text("Sortir"),
                    ),
                  ],
                ),
              ),
        child: Form(
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
                        return "Siusplau, posa un nom";
                      } else if (value.length > 30) {
                        return "Nom massa llarg (max. 30 caràcters)";
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
                      labelText: 'Nom del producte*',
                      counterText: "${compra.nom?.length ?? 0}/30",
                      helperText: "*Requerit",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: compra.descripcio,
                    validator: (value) {
                      value = value.trim();
                      if (value.length > 255) {
                        return "Descripció massa llarga (max. 255 caràcters)";
                      }
                      return null;
                    },
                    onChanged: (str) {
                      setState(() {
                        compra.descripcio =
                            (str.trim() == "") ? null : str.trim();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Descripció del producte',
                      counterText: "${compra.descripcio?.length ?? 0}/255",
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
                            .id,
                        items:
                            widget.llistesUsuari.map<DropdownMenuItem<String>>(
                          (Llista value) {
                            return DropdownMenuItem<String>(
                              value: value.id,
                              child: Text(value.nom),
                            );
                          },
                        ).toList(),
                        onChanged: (String newValue) {
                          indexLlista = widget.llistesUsuari.indexWhere(
                            (element) => element.id == newValue,
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
                      Text("Assigna un usuari de la llista"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            hint: Text("Selecciona un usuari"),
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
                          IconButton(
                            tooltip: "Desseleccionar assignat",
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                compra.idAssignat = null;
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
                            .map<DropdownMenuItem<Prioritat>>(
                                (Prioritat value) {
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
                            helpText: "SELECCIONA UNA DATA",
                            confirmText: "CONFIRMAR",
                            cancelText: "CANCEL·LAR",
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
                          final picked = await showDialog<double>(
                            context: context,
                            builder: (BuildContext context) {
                              return new NumberPickerDialog.decimal(
                                title: Text("Preu estimat en €"),
                                minValue: 1,
                                maxValue: 100,
                                decimalPlaces: 2,
                                initialDoubleValue: compra.preuEstimat ?? 1,
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
      ),
    );
  }
}
