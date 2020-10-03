import 'package:flutter/material.dart';
import 'package:totfet/models/Usuari.dart';

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
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    value = value.trim();
                    if (value == "") {
                      return "Has de tenir un nom.";
                    } else if (value.length > 15) {
                      return "El nom no pot tenir més de 15 caràcters.";
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
                    labelText: 'Nom d\'usuari*',
                    counterText: "${model.nom?.length ?? 0}/15",
                    helperText: "*Requerit",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    value = value.trim();
                    if (value.length > 255) {
                      return "La bio no pot tenir més de 255 caràcters.";
                    }
                    return null;
                  },
                  initialValue: model.bio,
                  onChanged: (str) {
                    setState(() {
                      model.bio = str;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Bio del perfil",
                    counterText: "${model.bio?.length ?? 0}/255",
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
