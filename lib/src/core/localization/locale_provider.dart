import 'package:flutter/material.dart';
import 'package:sample/src/core/caches/preferences/preferences_settings.dart';
import 'package:sample/src/core/localization/supported_locales.dart';

class LocaleProvider extends ChangeNotifier {
  LocaleProvider() {
    _loadSavedLocale();
  }
  Locale _locale = SupportedLocales.english;

  Locale get locale => _locale;

  Future<void> _loadSavedLocale() async {
    final cachedCode = SettingsPreferences.getLanguage();
    final cachedLocale = Locale(cachedCode);
    if (SupportedLocales.all.contains(cachedLocale)) {
      _locale = cachedLocale;
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (!SupportedLocales.all.contains(newLocale)) return;
    _locale = newLocale;
    await SettingsPreferences.setLanguage(newLocale.languageCode);
    notifyListeners();
  }

  void clearLocale() {
    _locale = SupportedLocales.english;
    notifyListeners();
  }

  String localeToString(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return 'Unknown';
    }
  }
}
