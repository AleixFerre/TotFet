import 'package:flutter/material.dart';

class AdminLlista extends StatefulWidget {
  @override
  _AdminLlistaState createState() => _AdminLlistaState();
}

class _AdminLlistaState extends State<AdminLlista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Crear una llista")),
      ),
      // mostrar totes les llistes en les que estas amb un stream builder
    );
  }
}
