import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/services/versionControl.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';

class OpcionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Configuració"),
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
      body: StreamBuilder<DocumentSnapshot>(
          stream: DatabaseService(uid: AuthService().userId).getUserData(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return SomeErrorPage(error: snapshot.error);
            }
            if (snapshot.hasData) {
              Map<String, dynamic> notificacions =
                  snapshot.data.data()['notificacions'];
              return SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Actualitzacions"),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 1,
                      onPressed: () async {
                        // Mostrar notes
                        await VersionControlService()
                            .mostrarNotesActualitzacio(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.receipt),
                          SizedBox(
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Notes de l'actualització",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 1,
                      onPressed: () async {
                        // Comprovar actualitzacions amb el nuvol
                        Map<String, dynamic> info =
                            await VersionControlService().checkUpdates();

                        // Confirmar si es vol anar a la pestanya del drive.
                        VersionControlService().showAlert(context, info);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.update),
                          SizedBox(
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Comprova actualitzacions",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 20,
                    ),
                    Text("Notificacions"),
                    Row(
                      children: [
                        Icon(notificacions['compres']
                            ? Icons.notifications
                            : Icons.notifications_off),
                        Text(
                          "Quan t'assignen una compra",
                          style: TextStyle(fontSize: 20),
                        ),
                        Expanded(child: Container()),
                        Switch(
                          value: notificacions['compres'],
                          onChanged: (bool val) {
                            notificacions['compres'] = val;
                            DatabaseService().actualitzarNotificacionsUsuari(
                              notificacions,
                              AuthService().userId,
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(notificacions['tasques']
                            ? Icons.notifications
                            : Icons.notifications_off),
                        Text(
                          "Quan t'assignen una tasca",
                          style: TextStyle(fontSize: 20),
                        ),
                        Expanded(child: Container()),
                        Switch(
                          value: notificacions['tasques'],
                          onChanged: (bool val) {
                            notificacions['tasques'] = val;
                            DatabaseService().actualitzarNotificacionsUsuari(
                              notificacions,
                              AuthService().userId,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return Scaffold(
              body: Loading(
                  esTaronja: false, msg: "Carregant dades de l'usuari..."),
            );
          }),
    );
  }
}
