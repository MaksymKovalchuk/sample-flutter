import 'package:sample/src/core/caches/preferences/preferences_settings.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme() : themeNotifier = ValueNotifier<ThemeMode>(_initialThemeMode());

  final ValueNotifier<ThemeMode> themeNotifier;

  ThemeMode get theme => themeNotifier.value;

  void setTypeTheme(int index) {
    final mode = index == 0
        ? ThemeMode.system
        : index == 1
            ? ThemeMode.light
            : ThemeMode.dark;

    themeNotifier.value = mode;
    SettingsPreferences.setDarkMode(index);
  }

  static ThemeMode _initialThemeMode() {
    switch (SettingsPreferences.darkMode()) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
