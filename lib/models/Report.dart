import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totfet/models/Prioritat.dart';
import 'package:totfet/models/Tipus_report.dart';

class Report {
  String titol;
  String descripcio;
  TipusReport tipus;
  Prioritat prioritat;
  String autor;
  String id;
  Timestamp dataCreacio;

  Report({
    this.titol,
    this.descripcio,
    this.prioritat,
    this.tipus,
    this.id,
    this.autor,
    this.dataCreacio,
  });

  static Report perDefecte(String autor) {
    return Report(
      prioritat: Prioritat.Normal,
      tipus: TipusReport.Error,
      autor: autor,
      dataCreacio: Timestamp.now(),
    );
  }

  Map<String, dynamic> toDBMap() {
    return {
      "titol": titol,
      "descripcio": descripcio,
      "tipus": tipusReportToString(tipus),
      "prioritat": prioritatToString(prioritat),
      "autor": autor,
      "dataCreacio": dataCreacio,
    };
  }

  static Report fromDB(Map<String, dynamic> data, String id) {
    return Report(
      id: id,
      titol: data['titol'],
      descripcio: data['descripcio'],
      tipus:
          data['tipus'] == null ? null : tipusReportfromString(data['tipus']),
      prioritat: data['prioritat'] == null
          ? null
          : prioritatfromString(data['prioritat']),
      autor: data['autor'],
      dataCreacio: data['dataCreacio'],
    );
  }
}
