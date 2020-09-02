enum Prioritat {
  Urgent,
  Alta,
  Normal, // Per defecte
  Baixa,
}

Prioritat prioritatfromString(String s) {
  return Prioritat.values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == s.toUpperCase());
}

String prioritatToString(Prioritat p) {
  return p.toString().substring(p.toString().indexOf('.') + 1);
}
