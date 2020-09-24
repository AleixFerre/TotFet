import 'package:flutter/material.dart';

enum TipusReport {
  Error,
  Millora,
  Idea,
  Ortografia,
  Altres,
}

Map<TipusReport, Icon> iconsTipusReport = {
  TipusReport.Error: Icon(Icons.error),
  TipusReport.Millora: Icon(Icons.upgrade),
  TipusReport.Idea: Icon(Icons.lightbulb),
  TipusReport.Ortografia: Icon(Icons.translate),
  TipusReport.Altres: Icon(Icons.help),
  null: Icon(Icons.help),
};

Map<TipusReport, String> descripcionsReport = {
  TipusReport.Error:
      "Gràcies per informar de l'error, el tindrem en compte per futures actualitzacions! :D",
  TipusReport.Millora: "Gràcies per fer millorar aquesta aplicació dia a dia!",
  TipusReport.Idea:
      "Gràcies per donar-nos idees! La tindrem en compte per futures actualitzacions! :D",
  TipusReport.Ortografia: "Ups... se'ns ha escapat l'accent, ho prometo!",
  TipusReport.Altres:
      "Gràcies pels teus comentaris! Ajuden a seguir fer créixer la app",
  null: "Gràcies pels teus comentaris! Ajuden a seguir fer créixer la app",
};

Icon tipusReportIcon(TipusReport tipus) {
  return iconsTipusReport[tipus];
}

String tipusReportDescripcio(TipusReport tipus) {
  return descripcionsReport[tipus];
}

String tipusReportToString(TipusReport p) {
  return p.toString().substring(p.toString().indexOf('.') + 1);
}
