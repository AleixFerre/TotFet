import 'package:flutter/material.dart';
import 'package:llista_de_la_compra/models/Prioritat/Prioritat.dart';
import 'package:llista_de_la_compra/models/Tipus/Tipus.dart';

class Compra {
  Compra({
    @required this.nom,
    this.tipus,
    this.quantitat,
    this.prioritat,
    this.data,
    this.preuEstimat,
  });

  String nom;
  Tipus tipus;
  double quantitat;
  Prioritat prioritat;
  DateTime data;
  int preuEstimat; // En euros

  // ignore: todo
  // TODO: QUI HA CREAT LA COMPRA
  // ignore: todo
  // TODO: PERSONA ASSIGNADA PER COMPRAR
  // ignore: todo
  // TODO: PERSONA COMPRADORA QUAN ES TANCA
}
