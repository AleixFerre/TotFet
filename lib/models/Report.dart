import 'package:totfet/models/Prioritat/Prioritat.dart';
import 'package:totfet/models/TipusReport.dart';

class Report {
  String titol;
  String descripcio;
  TipusReport tipus;
  Prioritat prioritat;

  Report() {
    titol = "";
    descripcio = "";
    tipus = TipusReport.Error;
    prioritat = Prioritat.Normal;
  }

  Map<String, dynamic> toDBMap() {
    return {
      "titol": titol,
      "descripcio": descripcio,
      "tipus": tipusReportToString(tipus),
      "prioritat": prioritatToString(prioritat),
    };
  }
}
