import 'package:flutter/material.dart';
import 'package:totfet/models/Ban.dart';
import 'package:totfet/models/Usuari.dart';

class BanUser extends StatefulWidget {
  final Usuari usuari;
  BanUser({this.usuari});
  @override
  _BanUserState createState() => _BanUserState();
}

class _BanUserState extends State<BanUser> {
  Usuari usuari;
  Ban ban;

  @override
  void initState() {
    super.initState();
    usuari = widget.usuari;
    ban = Ban.nou(usuari.uid);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banejar usuari"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Text(
                    "Ban a ${usuari.nom}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.topCenter,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            value = value.trim();
                            if (value == "") {
                              return "El ban ha de tenir un titol.";
                            } else if (value.length > 50) {
                              return "El nom és massa llarg (1-50 caràcters)";
                            }
                            return null;
                          },
                          initialValue: ban.titol ?? "",
                          onChanged: (str) {
                            setState(() {
                              ban.titol =
                                  (str.trim() == "") ? null : str.trim();
                            });
                          },
                          decoration: InputDecoration(
                            counterText: "${ban.titol?.length ?? 0}/50",
                            labelText: 'Entra el titol del ban',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.topCenter,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            value = value.trim();
                            if (value.length > 255) {
                              return "La descripció és massa llarg (1-255 caràcters)";
                            }
                            return null;
                          },
                          initialValue: ban.descripcio ?? "",
                          onChanged: (str) {
                            setState(() {
                              ban.descripcio =
                                  (str.trim() == "") ? null : str.trim();
                            });
                          },
                          decoration: InputDecoration(
                            counterText: "${ban.descripcio?.length ?? 0}/255",
                            labelText: 'Entra la descripcio de ban',
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.blueAccent,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.pop(context, ban);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Banejar',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.report,
                    size: 40,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
