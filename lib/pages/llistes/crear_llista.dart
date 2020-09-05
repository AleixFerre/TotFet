import 'package:compres/models/Llista.dart';
import 'package:flutter/material.dart';

class CrearLlista extends StatefulWidget {
  @override
  _CrearLlistaState createState() => _CrearLlistaState();
}

class _CrearLlistaState extends State<CrearLlista> {
  Llista llista = Llista.nova();

  final _formKey = GlobalKey<FormState>();

  // S'ha de posar:
  // Nom de la llista
  // Descripcio de la llista

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Crear una llista"),
        ),
      ),
      // EL FORMULARI
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
                      return "La llista ha de tenir un nom.";
                    } else if (value.length > 15) {
                      return "El nom és massa llarg (1-15 caràcters)";
                    }
                    return null;
                  },
                  initialValue: llista.nom ?? "",
                  onChanged: (str) {
                    setState(() {
                      llista.nom = str;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Entra el nom de la llista',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 5,
                  initialValue: llista.descripcio ?? "",
                  onChanged: (str) {
                    setState(() {
                      // Si el contingut es "" llavors sera null
                      // Sino, sera el contingut del string
                      llista.descripcio = (str == "") ? null : str;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Entra la descripció de la llista',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.pop(context, llista);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'Crear',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.post_add,
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
