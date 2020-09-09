import 'dart:ui';

import 'package:compres/shared/constants.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  Welcome({this.setWelcome});
  final Function setWelcome;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: 150.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.blue[400],
                    Colors.blue[900],
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10.0,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width, 100.0),
                ),
              ),
              child: Center(
                child: Text(
                  "Benvingut/da a $appName!",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.all(
                  Radius.elliptical(110, 120),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Image.asset(
                "images/favicon.png",
                height: 300,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: () {
                setWelcome(true);
              },
              child: SizedBox(
                width: 300,
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Icon(
                      Icons.login,
                      size: 50,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                setWelcome(false);
              },
              child: SizedBox(
                width: 300,
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Icon(
                      Icons.person_add,
                      size: 50,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
