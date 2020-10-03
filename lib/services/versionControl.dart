import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionControlService {
  Future<Map<String, dynamic>> checkUpdates() async {
    DocumentSnapshot version = await DatabaseService().getCurrentVersion();

    Map<String, dynamic> data = version.data();

    return checkCurrentVersion(data);
  }

  Future<DocumentSnapshot> updatesFuture() {
    // Just a wrapper of the function
    return DatabaseService().getCurrentVersion();
  }

  Future<List<dynamic>> getChanges() async {
    // Just a wrapper of the function
    DocumentSnapshot version = await DatabaseService().getCurrentVersion();
    return version.data()['changes'];
  }

  Map<String, dynamic> checkCurrentVersion(Map<String, dynamic> data) {
    if (data['index'] > versionIndex) {
      // Hi ha una versió nova
      return data;
    } else {
      // No hi ha cap versió nova
      return null;
    }
  }

  void showAlert(BuildContext context, Map info) {
    if (info != null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Existeix una versió més actual!'),
            content: Text(
              'Versió actual: $versionNumber\n' +
                  'Versió nova: ${info['tag']}.\n' +
                  "Vols actualitzar a la nova versió?",
            ),
            actions: [
              FlatButton(
                child: Text(
                  'Cancel·lar',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'Actualitzar',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  String url = info['url'];
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        titlePadding: const EdgeInsets.all(24),
                        title: Text("No es pot obrir l'enllaç :("),
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Yey! Tot al dia! 🎉🎉🎉"),
            children: [
              Text(
                "No existeix cap versió més actual de l'aplicació.",
              )
            ],
            contentPadding: EdgeInsets.all(24),
          );
        },
      );
    }
  }
}
