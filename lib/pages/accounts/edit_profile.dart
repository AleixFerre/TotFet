import 'package:flutter/material.dart';
import 'package:compres/models/Usuari.dart';

class EditPerfil extends StatefulWidget {
  final Usuari usuari;
  EditPerfil({this.usuari});
  @override
  _EditPerfilState createState() => _EditPerfilState();
}

class _EditPerfilState extends State<EditPerfil> {
  Usuari model;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    model = widget.usuari;
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar el perfil"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == "") {
                      return "Has de tenir un nom.";
                    } else if (value.length > 15) {
                      return "El nom no pot tenir més de 15 lletres.";
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
                    hintText: "Introdueix el teu nom",
                    labelText: 'Introdueix el teu nom...',
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                color: Colors.lightBlue,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.pop(context, model);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Guardar canvis",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.save,
                        size: 50,
                        color: Colors.white,
                      ),
                    ],
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
