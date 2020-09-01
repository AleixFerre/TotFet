import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:compres/models/Usuari.dart';
import 'package:compres/services/auth.dart';

class Perfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();
    Usuari usuari = _auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "User ID: " + usuari.uid,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
