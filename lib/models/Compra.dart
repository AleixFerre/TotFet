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
    this.nomCreador,
    this.idAssignat,
    this.nomAssignat,
    this.idComprador,
    this.nomComprador,
    @required this.idLlista,
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
  String nomCreador; // Només valid quan es fa la query
  // [idAssignat] pot ser null si encara no s'ha assignat
  String idAssignat; // ID de a qui està assignada
  String nomAssignat; // Només valid quan es fa la query
  // [idComprador] es null quan [comprat] és false
  String idComprador; // ID de qui la ha comprat
  String nomComprador; // Només valid quan es fa la query
  // ID de la llista a la que està inscrita la compra
  // [idLlista] no pot ser null
  String idLlista; // ID de qui la ha comprat
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
      nomCreador: data['nomCreador'],
      idAssignat: data['idAssignat'],
      nomAssignat: data['nomAssignat'],
      idComprador: data['idComprador'],
      nomComprador: data['nomComprador'],
      idLlista: data['idLlista'],
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
      'preuEstimat': preuEstimat,
      'dataPrevista': dataPrevista,
      'dataCreacio': dataCreacio,
      'dataCompra': dataCompra,
      'idCreador': idCreador,
      'idComprador': idComprador,
      'idAssignat': idAssignat,
      'idLlista': idLlista,
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
      'idAssignat': idAssignat,
      'idLlista': idLlista,
      'comprat': comprat,
    };
  }

  static Compra nova(_id, _idCreador, _idLlista) {
    // Retorna una compra nova per defecte
    return Compra(
      id: _id,
      nom: "",
      dataCreacio: Timestamp.fromDate(DateTime.now()),
      idCreador: _idCreador,
      prioritat: Prioritat.Normal,
      quantitat: 1,
      comprat: false,
      idLlista: _idLlista,
    );
  }
}
