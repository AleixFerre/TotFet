import 'package:flutter/material.dart';

enum Prioritat {
  Urgent,
  Alta,
  Normal, // Per defecte
  Baixa,
}

Map<Prioritat, Icon> prioritatIcons = {
  Prioritat.Urgent: Icon(Icons.error),
  Prioritat.Alta: Icon(Icons.warning),
  Prioritat.Normal: Icon(Icons.toll),
  Prioritat.Baixa: Icon(Icons.low_priority),
};

Prioritat prioritatfromString(String s) {
  return Prioritat.values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == s.toUpperCase());
}

String prioritatToString(Prioritat p) {
  return p.toString().substring(p.toString().indexOf('.') + 1);
}

Icon prioritatIcon(Prioritat p) {
  return prioritatIcons[p];
}
