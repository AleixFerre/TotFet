import 'dart:ui';

import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text("Sobre mi"),
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Realment, és sobre mi...",
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "Em dic Aleix i desarrollo aplicacions web i, normalment videjocs.",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Text(
              "Pots veure tot el que faig fent click als diferents botons d'aquí sota...",
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
