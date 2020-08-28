import 'package:flutter/material.dart';
import 'package:llista_de_la_compra/models/Compra.dart';
import 'package:llista_de_la_compra/models/tipus.dart';

class CreateCompra extends StatefulWidget {
  @override
  _CreateCompraState createState() => _CreateCompraState();
}

class _CreateCompraState extends State<CreateCompra> {
  Compra model = Compra(
    nom: "",
    tipus: null,
    quantitat: 1,
  );

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear"),
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
                      return "Siusplau, posa un nom";
                    }
                    return null;
                  },
                  initialValue: model.nom,
                  onChanged: (str) {
                    setState(() {
                      model.nom = str;
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
                child: DropdownButton<Tipus>(
                  hint: Text("Escolleix un tipus"),
                  value: model.tipus,
                  items:
                      Tipus.values.map<DropdownMenuItem<Tipus>>((Tipus value) {
                    return DropdownMenuItem<Tipus>(
                      value: value,
                      child: Text(value
                          .toString()
                          .substring(value.toString().indexOf('.') + 1)),
                    );
                  }).toList(),
                  onChanged: (Tipus newValue) {
                    setState(() {
                      model.tipus = newValue;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Quantitat"),
                    Slider(
                      value: model.quantitat,
                      min: 1,
                      max: 30,
                      divisions: 29,
                      label: "${model.quantitat}",
                      onChanged: (value) {
                        setState(() {
                          model.quantitat = value;
                        });
                      },
                    ),
                  ],
                ),
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
