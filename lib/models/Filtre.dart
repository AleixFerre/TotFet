class Filtre {
  Filtre({this.ordenarPer, this.filtratge});
  // Ordenar per <camp>
  String ordenarPer;
  // Si true ascendent, else descendent
  bool ordre;
  // Filtrar: [0] nom del camp | [1] el valor pel qual es comprova si es truthy
  Map<String, dynamic> filtratge;

  static Filtre nou(String ordenarPer, Map<String, dynamic> filtratge) {
    return Filtre(
      ordenarPer: ordenarPer,
      filtratge: filtratge ??
          {
            "camp": null,
            "valor": null,
          },
    );
  }

  void aplicarFiltre(List llista) {}
}
