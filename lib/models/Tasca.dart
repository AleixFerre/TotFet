import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totfet/models/Prioritat/Prioritat.dart';

class Tasca {
  Tasca({
    // Basic
    @required this.id,
    @required this.nom,
    this.descripcio,
    this.prioritat,
    this.fet,
    this.tempsEstimat,
    // Dates
    @required this.dataCreacio,
    this.dataPrevista,
    this.dataTancament,
    // Ids
    @required this.idCreador,
    this.nomCreador,
    this.idAssignat,
    this.nomAssignat,
    this.idUsuariFet,
    this.nomUsuariFet,
    @required this.idLlista,
  });

  // ID de la tasca a la base de dades
  String id;
  // Nom de la tasca
  String nom;
  // Descripcio de la tasca
  String descripcio;
  // Temps en hores estimat
  int tempsEstimat;
  // Prioritat de tasca (enum Prioritat)
  Prioritat prioritat;
  // [dataCreacio] no pot ser mai null
  Timestamp dataCreacio;
  // dataPrevista de tasca
  Timestamp dataPrevista;
  // data de tasca, si fet es false, [dataFet] és null
  Timestamp dataTancament;

  // [idCreador] no pot ser null mai
  String idCreador; // ID de qui ha creat la tasca
  String nomCreador; // Només valid quan es fa la query
  // [idAssignat] pot ser null si encara no s'ha assignat
  String idAssignat; // ID de a qui està assignada
  String nomAssignat; // Només valid quan es fa la query
  // [idTascador] es null quan [fet] és false
  String idUsuariFet; // ID de qui la ha fet (tancat)
  String nomUsuariFet; // Només valid quan es fa la query
  // ID de la llista a la que està inscrita la tasca
  // [idLlista] no pot ser null
  String idLlista; // ID de qui la ha tascat

  // Està fet?
  bool fet;

  // S'espera que les dates estiguin en format DateTime
  static Tasca fromDB(Map<String, dynamic> data) {
    return Tasca(
      id: data['id'],
      nom: data['nom'],
      descripcio: data['descripcio'],
      prioritat: prioritatfromString(data['prioritat']),
      tempsEstimat: data['tempsEstimat'],
      dataPrevista: data['dataPrevista'],
      dataCreacio: data['dataCreacio'],
      dataTancament: data['dataTancament'],
      idCreador: data['idCreador'],
      nomCreador: data['nomCreador'],
      idAssignat: data['idAssignat'],
      nomAssignat: data['nomAssignat'],
      idUsuariFet: data['idUsuariFet'],
      nomUsuariFet: data['nomUsuariFet'],
      idLlista: data['idLlista'],
      fet: data['fet'],
    );
  }

  Map<String, dynamic> toDBMap() {
    return {
      'nom': nom,
      'descripcio': descripcio,
      'prioritat':
          prioritat.toString().substring(prioritat.toString().indexOf('.') + 1),
      'dataPrevista': dataPrevista,
      'tempsEstimat': tempsEstimat,
      'dataCreacio': dataCreacio,
      'dataTancament': dataTancament,
      'idCreador': idCreador,
      'idAssignat': idAssignat,
      'idUsuariFet': idUsuariFet,
      'nomUsuariFet': nomUsuariFet,
      'idLlista': idLlista,
      'fet': fet,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'descripcio': descripcio,
      'tempsEstimat': tempsEstimat,
      'prioritat': prioritatToString(prioritat),
      'dataPrevista': dataPrevista,
      'dataCreacio': dataCreacio,
      'dataTancament': dataTancament,
      'idAssignat': idAssignat,
      'idLlista': idLlista,
      'fet': fet,
    };
  }

  static Tasca nova(_id, _idCreador, _idLlista) {
    // Retorna una tasca nova per defecte
    return Tasca(
      id: _id,
      nom: "",
      descripcio: "",
      dataCreacio: Timestamp.fromDate(DateTime.now()),
      idCreador: _idCreador,
      prioritat: Prioritat.Normal,
      idLlista: _idLlista,
      fet: false,
    );
  }
}
