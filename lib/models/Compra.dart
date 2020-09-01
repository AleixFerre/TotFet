import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:compres/models/Prioritat/Prioritat.dart';
import 'package:compres/models/Tipus/Tipus.dart';

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
  Timestamp data; // prevista
  int preuEstimat; // En euros

  // TODO: QUI HA CREAT LA COMPRA
  // TODO: PERSONA ASSIGNADA PER COMPRAR
  // TODO: PERSONA COMPRADORA QUAN ES TANCA
}
