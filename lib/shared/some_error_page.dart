import 'package:flutter/material.dart';

class SomeErrorPage extends StatelessWidget {
  SomeErrorPage({this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Llista de la compra"),
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
              child: Text(
                "Oops! Hi ha hagut un error, REINICIA LA APP",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 3,
              indent: 20,
              endIndent: 20,
              color: Colors.blue[200],
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
