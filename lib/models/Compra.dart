import 'package:flutter/material.dart';
import 'package:llista_de_la_compra/models/tipus.dart';

class Compra {
  Compra({
    @required this.nom,
    this.tipus,
    this.quantitat,
    this.prioritat,
  });

  String nom;
  Tipus tipus;
  double quantitat;
  double prioritat;
}
