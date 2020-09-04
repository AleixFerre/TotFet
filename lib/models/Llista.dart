import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Llista {
  String id;
  String nom;
  String descripcio;
  String idCreador;

  Llista({
    @required this.id,
    @required this.nom,
    @required this.idCreador,
    this.descripcio,
  });

  static Llista fromDB(QueryDocumentSnapshot doc) {
    return Llista(
      id: doc.id,
      nom: doc.data()['nom'] ?? "No disponible",
      descripcio: doc.data()['descripcio'],
      idCreador: doc.data()['idCreador'],
    );
  }

  // Retorna un mapa de ID llista - Nom llista
  static List<Map<String, String>> llistaPairs(List<Llista> list) {
    List<Map<String, String>> llistaFinal = [];
    for (Llista l in list) {
      llistaFinal.add({
        "id": l.id,
        "nom": l.nom,
      });
    }
    // S'ordena de forma alfabètica
    llistaFinal.sort((a, b) => a['nom'].compareTo(b['nom']));
    return llistaFinal;
  }
}
