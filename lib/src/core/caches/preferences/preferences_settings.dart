import 'package:sample/src/core/localization/supported_locales.dart';
import 'package:hive_ce/hive.dart';

import '../preferences.dart';
import 'preferences_keys.dart';

class SettingsPreferences {
  const SettingsPreferences._();

  static final Box<dynamic> _globalBox = Preferences.to.globalBox;

  static String getLanguage() => _globalBox.get(PreferencesKeys.currentLanguage,
      defaultValue: SupportedLocales.english.languageCode);
  static Future<void> setLanguage(String value) async =>
      await _globalBox.put(PreferencesKeys.currentLanguage, value);

  static int darkMode() =>
      _globalBox.get(PreferencesKeys.darkMode, defaultValue: 0);
  static Future<void> setDarkMode(int? value) async =>
      await _globalBox.put(PreferencesKeys.darkMode, value);
}
