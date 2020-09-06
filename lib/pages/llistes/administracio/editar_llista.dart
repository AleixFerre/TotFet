import 'package:flutter/material.dart';
import 'package:compres/models/Llista.dart';

class EditarLlista extends StatefulWidget {
  EditarLlista({this.llista});
  final Llista llista;
  @override
  _EditarLlistaState createState() => _EditarLlistaState();
}

class _EditarLlistaState extends State<EditarLlista> {
  Llista llista;

  @override
  void initState() {
    super.initState();
    llista = widget.llista;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Editar una llista"),
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
                    counterText:
                        "${llista.nom == null ? 0 : llista.nom.length}/15",
                    labelText: 'Entra el nom de la llista',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: TextFormField(
                  validator: (String value) {
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
                      llista.descripcio = (str == "") ? null : str;
                    });
                  },
                  decoration: InputDecoration(
                    counterText:
                        "${llista.descripcio == null ? "0" : llista.descripcio.length}/255",
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
                        'Editar',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SizedBox(width: 10),
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