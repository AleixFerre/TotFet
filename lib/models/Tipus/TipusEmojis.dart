import 'package:flutter/material.dart';

class TipusEmojis {
  TipusEmojis({this.tipus});
  String tipus;

  final Map<String, IconData> referencia = {
    "Menjar": Icons.fastfood,
    "Jardi": Icons.local_florist,
    "Piscina": Icons.pool,
    "Roba": Icons.content_cut,
    "Regal": Icons.redeem,
    "Informatica": Icons.devices,
    "Electrodomestic": Icons.dashboard,
    "Neteja": Icons.clean_hands,
    "Casa": Icons.house,
    "Salut": Icons.spa,
    "Esports": Icons.sports_soccer,
    "Jocs": Icons.sports_esports,
    "Altres": Icons.device_unknown,
  };

  Icon toIcon() {
    return Icon(referencia['$tipus']);
  }
}
