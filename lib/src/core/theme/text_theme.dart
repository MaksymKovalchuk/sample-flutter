import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:flutter/material.dart';
import 'typography.dart';

extension TextStylesNew on BuildContext {
  Color _resolveTone(Tone tone) => switch (tone) {
        Tone.primary => colors.cTextPrimary,
        Tone.secondary => colors.cTextSec,
        Tone.muted => colors.cTextMuted,
        Tone.active => colors.cTextSofter,
        Tone.brand => colors.cBtnPrimaryHover,
        Tone.buy => colors.cBtnBuy,
        Tone.sell => colors.cBtnSell,
        Tone.secondaryLight => colors.cBtnSecLghtr,
        Tone.yellow => colors.cWarningText,
      };

  TextStyle _ts(
    FontSize size, {
    required Tone tone,
    double? height = fHeight,
    double weight = regular,
    double width = defaultWidth,
    TextDecoration? decoration,
  }) =>
      StyleManager.styleText(
        size.px,
        color: _resolveTone(tone),
        weight: weight,
        height: height,
        width: width,
        decoration: decoration,
      );

  TextStyle textStyle({
    FontSize size = FontSize.md16,
    Tone tone = Tone.primary,
    double? height = fHeight,
    double weight = regular,
    double width = defaultWidth,
    TextDecoration? decoration,
  }) =>
      _ts(size,
          tone: tone,
          height: height,
          weight: weight,
          width: width,
          decoration: decoration);
}

extension TextStylesExtension on BuildContext {
  // fTiny size - 10
  TextStyle fTinyActive(
          {double? height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.ft10,
          tone: Tone.active,
          height: height,
          weight: weight,
          width: width);

  // fXTiny size - 11
  TextStyle fXTinySubText(
          {double? height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.fx11,
          tone: Tone.secondary,
          height: height,
          weight: weight,
          width: width);

  // xSmall size - 12
  TextStyle xSmallSubText(
          {double? height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xs12,
          tone: Tone.secondary,
          height: height,
          weight: weight,
          width: width);

  TextStyle xSmallText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xs12,
          tone: Tone.primary,
          height: height,
          weight: weight,
          width: width);

  TextStyle xSmallBtnSecondLig(
          {double? height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xs12,
          tone: Tone.secondaryLight,
          height: height,
          weight: weight,
          width: width);

  TextStyle xSmallGreen(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xs12,
          tone: Tone.buy,
          height: height,
          weight: weight,
          width: width);

  TextStyle xSmallRed(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xs12,
          tone: Tone.sell,
          height: height,
          weight: weight,
          width: width);

  TextStyle xSmallYellow(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xs12,
          tone: Tone.yellow,
          height: height,
          weight: weight,
          width: width);

  TextStyle xSmallActive(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xs12,
          tone: Tone.active,
          height: height,
          weight: weight,
          width: width);

  // small size - 13
  TextStyle smallText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm13,
          tone: Tone.primary,
          height: height,
          weight: weight,
          width: width);

  TextStyle smallSubText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm13,
          tone: Tone.secondary,
          height: height,
          weight: weight,
          width: width);

  TextStyle smallActive(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm13,
          tone: Tone.active,
          height: height,
          weight: weight,
          width: width);

  TextStyle smallGreen(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm13,
          tone: Tone.buy,
          height: height,
          weight: weight,
          width: width);

  TextStyle smallRed(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm13,
          tone: Tone.sell,
          height: height,
          weight: weight,
          width: width);

  TextStyle smallBrand(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm13,
          tone: Tone.brand,
          height: height,
          weight: weight,
          width: width);

  // lSmall - 14
  TextStyle lSmallText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth,
          TextDecoration? decoration}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm14,
          tone: Tone.primary,
          height: height,
          weight: weight,
          width: width,
          decoration: decoration);

  TextStyle lSmallSubText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm14,
          tone: Tone.secondary,
          height: height,
          weight: weight,
          width: width);

  TextStyle lSmallGreen(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm14,
          tone: Tone.buy,
          height: height,
          weight: weight,
          width: width);

  TextStyle lSmallRed(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm14,
          tone: Tone.sell,
          height: height,
          weight: weight,
          width: width);

  TextStyle lSmallBrand(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm14,
          tone: Tone.brand,
          height: height,
          weight: weight,
          width: width);

  TextStyle lSmallActive(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.sm14,
          tone: Tone.active,
          height: height,
          weight: weight,
          width: width);

  // medium - 16
  TextStyle mediumText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.md16,
          tone: Tone.primary,
          height: height,
          weight: weight,
          width: width);

  TextStyle mediumSubText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.md16,
          tone: Tone.secondary,
          height: height,
          weight: weight,
          width: width);

  TextStyle mediumBrand2(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.md16,
          tone: Tone.brand,
          height: height,
          weight: weight,
          width: width);

  TextStyle mediumActive(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.md16,
          tone: Tone.active,
          height: height,
          weight: weight,
          width: width);

  TextStyle mediumRed(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.md16,
          tone: Tone.sell,
          height: height,
          weight: weight,
          width: width);

  TextStyle mediumGreen(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.md16,
          tone: Tone.buy,
          height: height,
          weight: weight,
          width: width);

  // large - 18
  TextStyle largeText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.lg18,
          tone: Tone.primary,
          height: height,
          weight: weight,
          width: width);

  TextStyle largeBrand2(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.lg18,
          tone: Tone.brand,
          height: height,
          weight: weight,
          width: width);

  TextStyle largeActive(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.lg18,
          tone: Tone.active,
          height: height,
          weight: weight,
          width: width);

  // xLarge - 20
  TextStyle commonXLargeText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xl20,
          tone: Tone.primary,
          height: height,
          weight: weight,
          width: width);

  // 22
  TextStyle commonHugeText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xl22,
          tone: Tone.primary,
          height: height,
          weight: weight,
          width: width);

  // 24
  TextStyle xHugeText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xh24,
          tone: Tone.primary,
          height: height,
          weight: weight,
          width: width);

  // 30
  TextStyle commonXEnormousText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xe30,
          tone: Tone.primary,
          height: height,
          weight: weight,
          width: width);

  // 32
  TextStyle xLEnormousText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xe32,
          tone: Tone.primary,
          height: height,
          weight: weight,
          width: width);

  TextStyle xLEnormousSubText(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xe32,
          tone: Tone.secondary,
          height: height,
          weight: weight,
          width: width);

  TextStyle xLEnormousIconMuted(
          {double height = fHeight,
          double weight = regular,
          double width = defaultWidth}) =>
      TextStylesNew(this).textStyle(
          size: FontSize.xe32,
          tone: Tone.muted,
          height: height,
          weight: weight,
          width: width);
}
