import 'package:flutter/material.dart';
import 'package:totfet/models/Finestra.dart';
import 'package:totfet/models/Llista.dart';

class CrearLlista extends StatefulWidget {
  final Finestra finestra;
  CrearLlista({@required this.finestra});

  @override
  _CrearLlistaState createState() => _CrearLlistaState();
}

class _CrearLlistaState extends State<CrearLlista> {
  Llista llista = Llista.nova();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear una llista"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.finestra == Finestra.Tasques
                  ? <Color>[
                      Colors.orange[400],
                      Colors.deepOrange[900],
                    ]
                  : <Color>[
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
                      return "La llista ha de tenir un nom.";
                    } else if (value.length > 15) {
                      return "El nom és massa llarg (1-15 caràcters)";
                    }
                    return null;
                  },
                  initialValue: llista.nom ?? "",
                  onChanged: (str) {
                    setState(() {
                      llista.nom = (str.trim() == "") ? null : str.trim();
                    });
                  },
                  decoration: InputDecoration(
                    counterText: "${llista.nom?.length ?? 0}/15",
                    labelText: 'Nom de la llista*',
                    helperText: "*Requerit",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: TextFormField(
                  validator: (String value) {
                    value = value.trim();
                    if (value.length > 255)
                      return "La descripció és massa llarga (>255 caràcters)";
                    return null;
                  },
                  minLines: 1,
                  maxLines: 5,
                  initialValue: llista.descripcio ?? "",
                  onChanged: (str) {
                    setState(() {
                      // Si el contingut es "" llavors sera null
                      // Sino, sera el contingut del string
                      llista.descripcio =
                          (str.trim() == "") ? null : str.trim();
                    });
                  },
                  decoration: InputDecoration(
                    counterText: "${llista.descripcio?.length ?? 0}/255",
                    labelText: 'Descripció de la llista',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: widget.finestra == Finestra.Tasques
                    ? Colors.orange[400]
                    : Colors.blueAccent,
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
