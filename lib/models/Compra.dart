import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compres/models/Prioritat/Prioritat.dart';
import 'package:compres/models/Tipus/Tipus.dart';

class Compra {
  Compra({
    // basic
    @required this.id,
    @required this.nom,
    this.tipus,
    this.quantitat,
    this.prioritat,
    this.preuEstimat,
    this.comprat,
    // dates
    @required this.dataCreacio,
    this.dataPrevista,
    this.dataCompra,
    // Ids
    @required this.idCreador,
    this.idAssignat,
    this.idComprador,
  });

  // ID de la compra a la base de dades
  String id;
  // Nom de la compra
  String nom;
  // Tipus de compra (enum Tipus)
  Tipus tipus;
  // Quantitat de productes a comprar
  int quantitat;
  // Prioritat de compra (enum Prioritat)
  Prioritat prioritat;
  // [dataCreacio] no pot ser mai null
  Timestamp dataCreacio;
  // dataPrevista de compra
  Timestamp dataPrevista;
  // data de compra, si comprat es false, [dataCompra] és null
  Timestamp dataCompra;
  // Preu unitari estimat del producte en euros
  int preuEstimat;
  // [idCreador] no pot ser null mai
  String idCreador; // ID de qui ha creat la compra
  // [idAssignat] pot ser null si encara no s'ha assignat
  String idAssignat; // ID de a qui està assignada
  // [idComprador] es null quan [comprat] és false
  String idComprador; // ID de qui la ha comprat
  // Està comprat?
  bool comprat;

  // S'espera que les dates estiguin en format DateTime
  static Compra fromDB(Map<String, dynamic> data) {
    return Compra(
      id: data['id'],
      nom: data['nom'],
      tipus: tipusfromString(data['tipus']),
      quantitat: data['quantitat'],
      prioritat: prioritatfromString(data['prioritat']),
      preuEstimat: data['preuEstimat'],
      dataPrevista: data['dataPrevista'],
      dataCreacio: data['dataCreacio'],
      dataCompra: data['dataCompra'],
      idCreador: data['idCreador'],
      idAssignat: data['idAssignat'],
      idComprador: data['idComprador'],
      comprat: data['comprat'],
    );
  }

  Map<String, dynamic> toDBMap() {
    return {
      'nom': nom,
      'tipus': tipus == null
          ? "Altres"
          : tipus.toString().substring(tipus.toString().indexOf('.') + 1),
      'quantitat': quantitat,
      'prioritat':
          prioritat.toString().substring(prioritat.toString().indexOf('.') + 1),
      'dataPrevista': dataPrevista,
      'dataCreacio': dataCreacio,
      'dataCompra': dataCompra,
      'preuEstimat': preuEstimat,
      'idCreador': idCreador,
      'comprat': comprat,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'tipus': tipusToString(tipus),
      'quantitat': quantitat,
      'prioritat': prioritatToString(prioritat),
      'preuEstimat': preuEstimat,
      'dataPrevista': dataPrevista,
      'dataCreacio': dataCreacio,
      'dataCompra': dataCompra,
      'idCreador': idCreador,
      'idAssignat': idAssignat,
      'idComprador': idComprador,
      'comprat': comprat,
    };
  }

  static Compra nova(_id, _idCreador) {
    // Retorna una compra nova per defecte
    return Compra(
      id: _id,
      nom: "",
      dataCreacio: Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch),
      idCreador: _idCreador,
      prioritat: Prioritat.Normal,
      quantitat: 1,
      comprat: false,
    );
  }
}
