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

Tipus tipusfromString(String s) {
  return Tipus.values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == s.toUpperCase());
}

String tipusToString(Tipus t) {
  return t.toString().substring(t.toString().indexOf('.') + 1);
}
