import 'package:sample/src/core/constants/constants.dart';
import 'package:sample/src/core/theme/typography.dart';
import 'package:flutter/material.dart';

class StyleManager {
  const StyleManager._();

  static final Map<String, TextStyle> _styleCache = {};

  static TextStyle styleText(
    double fSize, {
    Color? color,
    double weight = regular,
    double width = defaultWidth,
    double? height = fHeight,
    double letterSpacing = 0,
    TextDecoration? decoration,
  }) {
    final key =
        '$fSize-${color?.value}-$weight-$width-$height-$letterSpacing-${_decorationKey(decoration)}';

    return _styleCache.putIfAbsent(
        key,
        () => TextStyle(
              fontSize: fSize,
              color: color,
              fontWeight: FontWeight.lerp(
                  FontWeight.w100, FontWeight.w900, weight / 900),
              letterSpacing: letterSpacing,
              height: height,
              decoration: decoration,
              fontFamily: Constants.fontFamily,
              fontVariations: [
                FontVariation('wdth', width),
                FontVariation('wght', weight),
              ],
            ));
  }

  static String _decorationKey(TextDecoration? decoration) {
    if (decoration == null) return 'none';
    if (decoration == TextDecoration.underline) return 'underline';
    if (decoration == TextDecoration.lineThrough) return 'lineThrough';
    if (decoration == TextDecoration.overline) return 'overline';
    return 'custom';
  }
}
