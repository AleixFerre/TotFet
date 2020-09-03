import 'package:flutter/material.dart';

class Llista {
  String nom;
  String descripcio;
  String idCreador;

  Llista({
    @required this.nom,
    @required this.idCreador,
    this.descripcio,
  });
}
