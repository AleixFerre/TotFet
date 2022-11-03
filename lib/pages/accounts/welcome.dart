import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:totfet/models/Finestra_auth.dart';
import 'package:totfet/shared/constants.dart';

class Welcome extends StatelessWidget {
  Welcome({this.canviarFinestra});
  final Function canviarFinestra;
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
                    MediaQuery.of(context).size.width,
                    100.0,
                  ),
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
            SvgPicture.asset(
              "images/welcome.svg",
              height: 200,
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            ElevatedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () {
                canviarFinestra(FinestraAuth.SignIn);
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
                      "Inicia la sessió",
                      style: TextStyle(
                        fontSize: 37,
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
            ElevatedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () {
                canviarFinestra(FinestraAuth.Register);
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
                      "Registrar-se",
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
