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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value == "") {
                      return "Has de tenir un nom.";
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
                    labelText: 'Introdueix el teu nom...',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context, model);
                  },
                  child: Text("Guardar canvis"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
