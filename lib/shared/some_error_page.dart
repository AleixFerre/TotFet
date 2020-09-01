import 'package:flutter/material.dart';

class SomeErrorPage extends StatelessWidget {
  SomeErrorPage({this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Error"),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                    "Oops! Sembla que alguna cosa ha sortit malament...\n",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Envia una captura d'aquesta pàgina a algun administrador explicant quan i com ha passat per poder arregar l'error l'abans possible. " +
                        "Quan ja ho hagis fet, pots reiniciar la aplicació.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 3,
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "ERROR: $error",
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
