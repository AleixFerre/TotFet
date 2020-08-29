import 'package:flutter/material.dart';

class PrioritatColor {
  String prioritat;
  PrioritatColor({this.prioritat});
  // Urgent,
  // Alta,
  // Normal, // Per defecte
  // Baixa,

  Map<String, Color> referenceColor = {
    'Urgent': Color(0xffd62828),
    'Alta': Color(0xfff77f00),
    'Normal': Colors.white,
    'Baixa': Color(0xffeae2b7),
    null: Colors.white,
  };

  Map<String, String> referenceString = {
    'Urgent': "És urgent!",
    'Alta': "Prioritat alta",
    'Normal': "",
    'Baixa': "No és important",
    null: "",
  };

  Color toColor() {
    return referenceColor[prioritat];
  }

  String toString() {
    return referenceString[prioritat];
  }
}
