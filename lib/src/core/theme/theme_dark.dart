import 'package:sample/src/core/theme/colors.dart';
import 'package:flutter/material.dart';

class DarkTheme {
  const DarkTheme._();

  static ThemeData create(BuildContext context) => ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        hintColor: context.colors.cTextPrimary,
        cardColor: context.colors.cBgMain,
        hoverColor: context.colors.cTextSec,
        disabledColor: context.colors.cTextPrimary,
        splashColor: Colors.transparent,
        canvasColor: Colors.transparent,
        highlightColor: Colors.transparent,
        appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          dragHandleColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          onSurface: context.colors.cBtnPrimary,
          secondary: context.colors.cTextPrimary,
        ),
      );
}
