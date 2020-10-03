import 'package:flutter/material.dart';

enum Tipus {
  Menjar,
  Jardi,
  Piscina,
  Roba,
  Regal,
  Informatica,
  Electrodomestic,
  Neteja,
  Casa,
  Salut,
  Esports,
  Jocs,
  Altres,
}

Map<Tipus, IconData> iconsTipus = {
  Tipus.Menjar: Icons.fastfood,
  Tipus.Jardi: Icons.local_florist,
  Tipus.Piscina: Icons.pool,
  Tipus.Roba: Icons.content_cut,
  Tipus.Regal: Icons.redeem,
  Tipus.Informatica: Icons.devices,
  Tipus.Electrodomestic: Icons.dashboard,
  Tipus.Neteja: Icons.clean_hands,
  Tipus.Casa: Icons.home,
  Tipus.Salut: Icons.spa,
  Tipus.Esports: Icons.sports_soccer,
  Tipus.Jocs: Icons.sports_esports,
  Tipus.Altres: Icons.help_outline,
  null: Icons.help_outline,
};

Tipus tipusfromString(String s) {
  return Tipus.values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == s.toUpperCase());
}

Icon tipustoIcon(Tipus tipus) {
  return Icon(iconsTipus[tipus]);
}

Icon tipusStringtoIcon(String s) {
  Tipus tipus = tipusfromString(s);
  print(s);
  return Icon(iconsTipus[tipus]);
}

String tipusToString(Tipus t) {
  return t.toString().substring(t.toString().indexOf('.') + 1);
}
