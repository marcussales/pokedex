import 'package:flutter/material.dart';
import 'package:pokedex/utils/poketypes.dart';

import '../data/models/PokemonDetailModel.dart';

class ColorsUtil {
  static final cinzaEscuro = getColorByHex('#464646');
  static final amarelo = getColorByHex('#FFCC00');
  static final ocre = getColorByHex('#A88600');
  static final preto = getColorByHex('#262626');
  static final defaultType = getColorByHex('#1B3A4D');
  static final azul = getColorByHex('#0073BC');
  static final water = getColorByHex('#0073BC');
  static final grass = getColorByHex('#82BE41');
  static final fire = getColorByHex('#D35151');
  static final eletric = getColorByHex('#EECC43');
  static final normal = getColorByHex('##A5A5A5');
  static final bug = getColorByHex('#DA8638');
  static final fairy = getColorByHex('EA77D0');
  static final poison = getColorByHex('5A005D');

  static Color getColorByHex(String hex) {
    return Color(int.parse("0xFF${hex.replaceAll('#', '')}"));
  }

  static Color getColorByType(Types? type) {
    var typeName = type?.type?.name;
    switch (typeName) {
      case GRASS:
        return grass;
      case FIRE:
        return fire;
      case WATER:
        return water;
      case ELETRIC:
        return eletric;
      case NORMAL:
        return normal;
      case BUG:
        return bug;
      case FAIRY:
        return fairy;
      default:
        return defaultType;
    }
  }
}
