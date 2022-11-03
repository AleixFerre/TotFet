import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totfet/services/auth.dart';

class Llista {
  String id;
  String nom;
  String descripcio;
  String idCreador;

  Llista({
    @required this.id,
    @required this.nom,
    this.idCreador,
    this.descripcio,
  });

  Map<String, String> toDBMap() {
    return {
      "nom": nom,
      "descripcio": descripcio,
      "idCreador": idCreador,
    };
  }

  static Llista fromDB(QueryDocumentSnapshot doc) {
    return Llista(
      id: doc.id,
      nom: doc['nom'] ?? "No disponible",
      descripcio: doc['descripcio'] == "" ? null : doc['descripcio'],
      idCreador: doc['idCreador'],
    );
  }

  static Llista fromDBMap(Map<String, String> doc) {
    return Llista(
      id: doc['id'],
      nom: doc['nom'] ?? "No disponible",
      descripcio: doc['descripcio'] == "" ? null : doc['descripcio'],
      idCreador: doc['idCreador'],
    );
  }

  static Llista fromMap(Map<String, dynamic> llista) {
    return Llista(
      id: llista['id'],
      nom: llista['nom'],
      descripcio: llista['descripcio'],
      idCreador: llista['idCreador'],
    );
  }

  // Retorna un mapa de ID llista - Nom llista
  static List<Llista> llistaPairs(List<Llista> list) {
    List<Llista> llistaFinal = [];
    for (Llista l in list) {
      llistaFinal.add(
        Llista(
          id: l.id,
          nom: l.nom,
          descripcio: l.descripcio,
          idCreador: l.idCreador,
        ),
      );
    }
    return llistaFinal;
  }

  static Llista nova() {
    return Llista(
      id: null,
      nom: null,
      descripcio: null,
      idCreador: AuthService().userId,
    );
  }
}
