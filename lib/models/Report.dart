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
  Timestamp dataTancament;
  bool obert;
  String tancatPer;

  Report({
    this.titol,
    this.descripcio,
    this.prioritat,
    this.tipus,
    this.id,
    this.autor,
    this.dataCreacio,
    this.obert,
    this.tancatPer,
    this.dataTancament,
  });

  static Report perDefecte(String autor) {
    return Report(
      prioritat: Prioritat.Normal,
      tipus: TipusReport.Error,
      autor: autor,
      dataCreacio: Timestamp.now(),
      obert: true,
      tancatPer: null,
      dataTancament: null,
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
      "obert": obert,
      "tancatPer": tancatPer,
      "dataTancament": dataTancament,
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
      obert: data['obert'],
      tancatPer: data['tancatPer'],
      dataTancament: data['dataTancament'],
    );
  }
}
