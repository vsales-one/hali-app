import 'package:flutter/cupertino.dart';

class ColorUtils {

  // colors
  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

}
const colorEFADAE = "#EFADAE";
const color1D1D1D = "#1D1D1D";
const colorF0857A = "#F0857A";
const colorD92c27 = "#D92C27";
