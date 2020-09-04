import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  Welcome({this.setWelcome});
  final Function setWelcome;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Benvingut/da a Compres!")),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("Welcome"),
            ),
            RaisedButton(
              onPressed: () {
                setWelcome(true);
              },
              child: Text("Login"),
            ),
            RaisedButton(
              onPressed: () {
                setWelcome(false);
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
