import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_utils.dart';

abstract class Styles {

  static const headlineText = TextStyle(
    color: Colors.white,
    fontFamily: 'OpenSans-Bold',
    fontSize: 25,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static final  headlineBlackText = TextStyle(
    color: ColorUtils.hexToColor(colorEFADAE),
    fontFamily: 'OpenSans-Bold',
    fontSize: 25,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static final minorBlackText = TextStyle(
    color: ColorUtils.hexToColor(color1D1D1D),
    fontFamily: 'OpenSans-Semibold',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static final minorWhiteText = TextStyle(
    color: Colors.white,
    fontFamily: 'OpenSans-Semibold',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static getRegularStyle(double size, Color color, [TextDecoration decoration]) {
    return TextStyle(
      decoration: decoration == null ? TextDecoration.none
          : decoration,
      decorationColor: decoration == null ? null : Colors.black54,
      decorationStyle: decoration == null ? null : TextDecorationStyle.solid,
      decorationThickness: 1,
      color: color,
      fontFamily: 'OpenSans-Regular',
      fontSize: size,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
    );
  }

  static getRegularStyleWithDecoration(double size, Color color, TextDecoration decoration) {
    return TextStyle(
      decoration: TextDecoration.underline,
      color: color,
      fontFamily: 'OpenSans-Regular',
      fontSize: size,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
    );
  }

  static getSemiboldStyle(double size, Color color, [TextDecoration decoration]) {
    return TextStyle(
      decoration: decoration == null ? TextDecoration.none
          : decoration,
      decorationColor: decoration == null ? null : Colors.black54,
      decorationStyle: decoration == null ? null : TextDecorationStyle.solid,
      decorationThickness: 1,
      color: color,
      fontFamily: 'OpenSans-Semibold',
      fontSize: size,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
    );
  }

}