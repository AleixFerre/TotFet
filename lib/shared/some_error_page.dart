import 'package:flutter/material.dart';
import 'package:totfet/shared/sortir_sessio.dart';

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
        actions: [
          SortirSessio(),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Text(
              "Oops! Sembla que alguna cosa ha sortit malament...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              height: 50,
              thickness: 3,
              indent: 20,
              endIndent: 20,
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
