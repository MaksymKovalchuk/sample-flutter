import 'package:hive_ce/hive.dart';
import 'package:sample/src/core/caches/preferences.dart';
import 'package:sample/src/core/caches/preferences/preferences_keys.dart';
import 'package:sample/src/core/localization/supported_locales.dart';

class SettingsPreferences {
  const SettingsPreferences._();

  static final Box<dynamic> _globalBox = Preferences.to.globalBox;

  static String getLanguage() =>
      _globalBox.get(
            PreferencesKeys.currentLanguage,
            defaultValue: SupportedLocales.english.languageCode,
          )
          as String;
  static Future<void> setLanguage(String value) async =>
      _globalBox.put(PreferencesKeys.currentLanguage, value);

  static int darkMode() =>
      _globalBox.get(PreferencesKeys.darkMode, defaultValue: 0) as int;
  static Future<void> setDarkMode(int? value) async =>
      _globalBox.put(PreferencesKeys.darkMode, value);
}
