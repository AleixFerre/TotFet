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
    @required this.idCreador,
    this.idAssignat,
    this.idComprador,
  });

  String nom;
  Tipus tipus;
  int quantitat;
  Prioritat prioritat;
  Timestamp data; // prevista
  int preuEstimat; // En euros
  // [idCreador] no pot ser null mai
  String idCreador; // ID de qui ha creat la compra
  // [idAssignat] pot ser null si encara no s'ha assignat
  String idAssignat; // ID de a qui està assignada
  // [idComprador] es null quan [comprat] és false
  String idComprador; // ID de qui la ha comprat
}
