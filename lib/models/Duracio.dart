class Duracio {
  int hores;
  int minuts;
  Duracio({this.hores, this.minuts});

  bool esZero() {
    return hores == 0 && minuts == 0;
  }

  String toString() {
    String all = "";

    if (hores != null && hores != 0) {
      all += "${hores}h";
      if (minuts != null) {
        all += " ";
      }
    }

    if (minuts != null && minuts != 0) {
      all += "${minuts}min";
    }

    return all;
  }

  List toList() {
    return [hores, minuts];
  }

  static Duracio fromList(List l) {
    if (l == null) return null;
    return Duracio(hores: l[0], minuts: l[1]);
  }
}
