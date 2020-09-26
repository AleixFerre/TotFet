import 'package:totfet/models/Prioritat/Prioritat.dart';
import 'package:totfet/models/TipusReport.dart';

class Report {
  String titol;
  String descripcio;
  TipusReport tipus;
  Prioritat prioritat;
  String autor;
  String id;

  Report({
    this.titol,
    this.descripcio,
    this.prioritat,
    this.tipus,
    this.id,
    this.autor,
  });

  Map<String, dynamic> toDBMap() {
    return {
      "titol": titol,
      "descripcio": descripcio,
      "tipus": tipusReportToString(tipus),
      "prioritat": prioritatToString(prioritat),
      "autor": autor,
    };
  }

  static Report fromDB(Map<String, dynamic> data, String id) {
    return Report(
      id: id,
      titol: data['titol'],
      descripcio: data['descripcio'],
      tipus: tipusReportfromString(data['tipus']),
      prioritat: prioritatfromString(data['prioritat']),
      autor: data['autor'],
    );
  }
}
