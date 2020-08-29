import 'package:flutter/material.dart';
import 'package:llista_de_la_compra/models/Prioritat/Prioritat.dart';
import 'package:llista_de_la_compra/models/Tipus/Tipus.dart';
import 'package:numberpicker/numberpicker.dart';

class EditCompra extends StatefulWidget {
  final Map<String, dynamic> compra;
  EditCompra({this.compra});

  @override
  _EditCompraState createState() => _EditCompraState();
}

class _EditCompraState extends State<EditCompra> {
  Map<String, dynamic> model;

  final _formKey = GlobalKey<FormState>();

  String readTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    String str = date.day.toString().padLeft(2, "0") +
        "/" +
        date.month.toString().padLeft(2, "0") +
        "/" +
        date.year.toString();

    return str;
  }

  @override
  Widget build(BuildContext context) {
    model = widget.compra;
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Compra"),
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
                    if (value == "") {
                      return "Siusplau, posa un nom a la compra.";
                    }
                    return null;
                  },
                  initialValue: model['nom'],
                  onChanged: (str) {
                    setState(() {
                      model['nom'] = str;
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
                                : readTimestamp(model['dataPrevista'].seconds),
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
                          initialDate: DateTime.fromMillisecondsSinceEpoch(
                              model['dataPrevista'].seconds * 1000),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        setState(() {
                          model['dataPrevista'] = picked;
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
                              minValue: 0,
                              maxValue: 100,
                              initialIntegerValue: model['preuEstimat'] ?? 0,
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
                  if (_formKey.currentState.validate())
                    Navigator.pop(context, model);
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
