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

Map<Prioritat, Color> prioritatColors = {
  Prioritat.Urgent: Color(0xffd62828),
  Prioritat.Alta: Color(0xfff77f00),
  Prioritat.Normal: Colors.white,
  Prioritat.Baixa: Color(0xffeae2b7),
  null: Colors.white,
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

Color prioritatStringColor(String p) {
  return prioritatColors[prioritatfromString(p)];
}

Color prioritatColor(Prioritat p) {
  return prioritatColors[p];
}
