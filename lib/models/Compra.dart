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
  int quantitat;
  Prioritat prioritat;
  DateTime data; // prevista
  int preuEstimat; // En euros

  // TODO: QUI HA CREAT LA COMPRA
  // TODO: PERSONA ASSIGNADA PER COMPRAR
  // TODO: PERSONA COMPRADORA QUAN ES TANCA
}
