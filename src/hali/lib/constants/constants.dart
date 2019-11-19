import 'package:flutter/cupertino.dart';

/// Construct a color from a hex code string, of the format #RRGGBB.
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

const redPrimary = "#D92C27";
const black1D1D1D = "#1D1D1D";