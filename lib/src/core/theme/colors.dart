import 'package:flutter/material.dart';

extension ThemeModeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

extension ColorTheme on BuildContext {
  static final Map<ThemeData, ColorCache> _themeCache = {};

  ColorCache get colors {
    final theme = Theme.of(this);
    return _themeCache.putIfAbsent(theme, () => ColorCache(theme.brightness));
  }
}

class ColorCache {
  ColorCache(this.brightness);
  final Brightness brightness;

  Color _dynamic(int light, int dark) =>
      brightness == Brightness.light ? Color(light) : Color(dark);

  // -- 0 --
  // button-text-primary
  late final Color cButtonText = _dynamic(0xFFFFFFFF, 0xFFFFFFFF);

  // -- 1900 --
  // background-main
  late final Color cBgMain = _dynamic(0xFFF5F5F7, 0xFF0D0E10);

  // -- 1600 --
  // background-block
  late final Color cBgBlock = _dynamic(0xFFFFFFFF, 0xFF15161B);
  // field-background
  late final Color cBgField = _dynamic(0xFFFFFFFF, 0xFF15161B);

  /// -- 1300 --
  // background-block-hover
  late final Color cBgHover = _dynamic(0xFFFFFFFF, 0xFF1D1E24);
  // button-disabled
  late final Color cBtnDisabled = _dynamic(0xFFDEDFE5, 0xFF1D1E24);
  // button-tertiary
  late final Color cBtnTertiary = _dynamic(0xFFF5F5F7, 0xFF1D1E24);
  // status-neutral-background
  late final Color cStatusBg = _dynamic(0xFFEFEFF2, 0xFF25262D);

  // -- 1500 --
  // background-sheets
  late final Color cBgSheets = _dynamic(0xFFFFFFFF, 0xFF18191D);
  // dropdown-background
  late final Color cDropdownBg = _dynamic(0xFFF5F5F7, 0xFF18191D);

  // -- 1100 --
  // field-tap
  late final Color cFieldTap = _dynamic(0xFFFFFFFF, 0xFF25262D);
  // field-background-lighter
  late final Color cFieldBgLghtr = _dynamic(0xFFF5F5F7, 0xFF25262D);
  // dropdown-hover
  late final Color cDropdownHover = _dynamic(0xFFF5F5F7, 0xFF25262D);
  // button-tertiary-focus
  late final Color cBtnTertiaryFocus = _dynamic(0xFFF5F5F7, 0xFF25262D);
  // button-bar
  late final Color cBtnBar = _dynamic(0xFF25262D, 0xFF25262D);

  // -- 1400 --
  // field-focus
  late final Color cFieldFocus = _dynamic(0xFFFFFFFF, 0xFF1B1C21);
  // field-dropdown
  late final Color cFieldDropdown = _dynamic(0xFFF5F5F7, 0xFF1B1C21);

  // -- 1700 --
  // field-disabled
  late final Color cFieldDisabled = _dynamic(0xFFFFFFFF, 0xFF141519);

  // -- 900 --
  // field-focus-lighter
  late final Color cFieldFocusLghtr = _dynamic(0xFFF5F5F7, 0xFF2B2D35);
  // field-dropdown-hover
  late final Color cFieldDropdownHover = _dynamic(0xFFF5F5F7, 0xFF2B2D35);
  // button-secondary
  late final Color cBtnSec = _dynamic(0xFFFFFFFF, 0xFF2B2D35);
  // button-secondary-lighter-disabled
  late final Color cBtnSecLghtrDisabled = _dynamic(0xFFF5F5F7, 0xFF2B2D35);
  // outline
  late final Color cOutline = _dynamic(0xFFDEDFE5, 0xFF2B2D35);

  // -- 1200 --
  // field-disbaled-lighter
  late final Color cFieldDisbaledLghtr = _dynamic(0xFFF8F8F9, 0xFF202228);

  // -- 20 --
  // text-primary
  late final Color cTextPrimary = _dynamic(0xFF26272E, 0xFFEFEFF2);
  // icon-active
  late final Color cIconActive = _dynamic(0xFF26272E, 0xFFEFEFF2);

  // -- 75 --
  // text-primary-softer
  late final Color cTextSofter = _dynamic(0xFF30323B, 0xFFC6C8D1);
  // icon-active-softer
  late final Color cIconActiveSofter = _dynamic(0xFF30323B, 0xFFC6C8D1);

  // -- 300 --
  // text-secondary
  late final Color cTextSec = _dynamic(0xFF818699, 0xFF818699);
  // icon-muted-lighter
  late final Color cIconMutedLghtr = _dynamic(0xFFA9ADB9, 0xFF818699);
  // status-neutral
  late final Color cStatusNeutral = _dynamic(0xFF818699, 0xFF818699); //light ??

  // -- 700 --
  // text-muted
  late final Color cTextMuted = _dynamic(0xFFA9ADB9, 0xFF343740);
  // icon-muted
  late final Color cIconMuted = _dynamic(0xFFA9ADB9, 0xFF343740);
  // button-secondary-lighter-focus
  late final Color cBtnSecLghtrFocus = _dynamic(0xFFF5F5F7, 0xFF343740);

  // -- 400 --
  // icon-default
  late final Color cIconDefault = _dynamic(0xFF818699, 0xFF63677A);

  // -- 800 --
  // button-secondary-focus
  late final Color cBtnSecFocus = _dynamic(0xFFFFFFFF, 0xFF30323B);
  // button-secondary-lighter
  late final Color cBtnSecLghtr = _dynamic(0xFFF5F5F7, 0xFF30323B);
  // outline-text
  late final Color cOutlineText = _dynamic(0xFFA9ADB9, 0xFF30323B);
  // skeleton
  late final Color cSkeleton = _dynamic(0xFFA9ADB9, 0xFF30323B);

  // -- Primary --
  // button-primary
  late final Color cBtnPrimary = _dynamic(0xFF004DFF, 0xFF004DFF);
  // primary
  late final Color cPrimary = _dynamic(0xFF004DFF, 0xFF004DFF);

  // -- Pry-lighter --
  // button-primary-hover
  late final Color cBtnPrimaryHover = _dynamic(0xFF2164FF, 0xFF2164FF);
  // primary-lighter
  late final Color cPrimaryLghtr = _dynamic(0xFF2164FF, 0xFF2164FF);

  // -- Pry-lighter2 --
  late final Color cPrimaryLghtr2 = _dynamic(0xFF1B76FF, 0xFF1B76FF);

  // -- Secondary --
  late final Color cSecondary = _dynamic(0xFF00E0F3, 0xFF00E0F3);

  // -- Yellow --
  // status-warning-text
  late final Color cWarningText = _dynamic(0xFFFFB200, 0xFFFEC84B);
  // status-warning-background
  late final Color cWarningBg =
      _dynamic(0xFFFFB200, 0xFFFEC84B).withValues(alpha: 0.1);

  // -- Green --
  // button-trade-buy
  late final Color cBtnBuy = _dynamic(0xFF1ABC9C, 0xFF1ABC9C);
  // status-success
  late final Color cStatusSuccess = _dynamic(0xFF1ABC9C, 0xFF1ABC9C);
  // status-success-background
  late final Color cSuccessBg =
      _dynamic(0xFF1ABC9C, 0xFF1ABC9C).withValues(alpha: 0.1);

  // -- Red --
  // button-trade-sell
  late final Color cBtnSell = _dynamic(0xFFDD2252, 0xFFE9305B);
  // status-error
  late final Color cStatusError = _dynamic(0xFFDD2252, 0xFFE9305B);
  // status-error-field-stroke
  late final Color cStatusErrorFieldStroke =
      _dynamic(0xFFDD2252, 0xFFE9305B).withValues(alpha: 0.5);
  // status-error-background
  late final Color cStatusErrorBg =
      _dynamic(0xFFDD2252, 0xFFE9305B).withValues(alpha: 0.1);
  // status-error-field
  late final Color cStatusErrorField =
      _dynamic(0xFFDD2252, 0xFFE9305B).withValues(alpha: 0.05);

  late final Color cBlack = const Color(0xFF000000);
  late final Color cAsset1 = const Color(0xFF65E1CE);
  late final Color cAsset2 = const Color(0xFF0098EA);
  late final Color cAsset3 = const Color(0xFFFF3283);
  late final Color cAsset4 = const Color(0xFF9391F7);
  late final Color cAsset5 = const Color(0xFFFFAC3C);
  late final Color cAsset6 = const Color(0xFFFF1861);
  late final Color cProfile = const Color(0xFF8D76F4);

  late final Color cTabGradient1 = _dynamic(0xFFFFFFFF, 0xFF21252A);
  late final Color cTabGradient2 = _dynamic(0xFFEBEBEB, 0xFF21252B);
  late final Color cTabGradient3 = _dynamic(0xFFFFFFFF, 0xFF21252A);
  late final Color cTabBg = _dynamic(0xFFFFFFFF, 0xFF101114);

  late final Color cYellowBanner = _dynamic(0xFFE2E1DB, 0xFF342C1C);
  late final Color cRedBanner = _dynamic(0xFFE2E1DB, 0xFF28121B);
  late final Color cGreenBanner = _dynamic(0xFFE2E1DB, 0xFF112723);
  late final Color cBlueBanner = _dynamic(0xFFE2E1DB, 0xFF151C34);

  String colorToHex(Color color, {bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${color.red.toRadixString(16).padLeft(2, '0')}'
      '${color.green.toRadixString(16).padLeft(2, '0')}'
      '${color.blue.toRadixString(16).padLeft(2, '0')}';
}
