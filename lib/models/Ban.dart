class Ban {
  String idUsuari;
  String banejatPer;
  String titol;
  String descripcio;

  Ban({this.idUsuari, this.titol, this.descripcio, this.banejatPer});

  static Ban nou(String idUsuari) {
    return Ban(idUsuari: idUsuari, titol: "", descripcio: "");
  }

  Map<String, dynamic> toDBMap() {
    return {
      "titol": titol,
      "descripcio": descripcio,
      "banejatPer": banejatPer,
    };
  }

  static Ban fromDBMap(Map<String, dynamic> data) {
    return Ban(
      idUsuari: data['idUsuari'],
      titol: data['titol'],
      descripcio: data['descripcio'],
      banejatPer: data['banejatPer'],
    );
  }
}
