class Actualitzacio {
  int index;
  String longName;
  String tag;
  String url;
  List<dynamic> changes;

  Actualitzacio({this.index, this.longName, this.tag, this.url, this.changes});

  static Actualitzacio fromData(Map data) {
    return Actualitzacio(
      index: data['index'],
      longName: data['long_name'],
      tag: data['tag'],
      url: data['url'],
      changes: data['changes'],
    );
  }
}
