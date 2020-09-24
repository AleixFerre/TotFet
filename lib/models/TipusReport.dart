enum TipusReport {
  Error,
  Millora,
}

String tipusReportToString(TipusReport p) {
  return p.toString().substring(p.toString().indexOf('.') + 1);
}
