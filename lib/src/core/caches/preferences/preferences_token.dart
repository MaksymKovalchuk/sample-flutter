import 'package:sample/src/core/caches/preferences/preferences_keys.dart';

import '../preferences.dart';

class TokenPreferences {
  const TokenPreferences._();

  static final _box = Preferences.to.prefBox;
  static final _secure = Preferences.to.secureStorage;

  static Future<void> setAccessToken(String value) async =>
      await _secure.write(key: PreferencesKeys.accessToken, value: value);
  static Future<String?> accessToken() async =>
      await _secure.read(key: PreferencesKeys.accessToken);

  static Future<void> setRefreshToken(String value) async =>
      await _secure.write(key: PreferencesKeys.refreshToken, value: value);
  static Future<String?> refreshToken() async =>
      await _secure.read(key: PreferencesKeys.refreshToken);

  static Future<void> clearTokens() async {
    await _secure.delete(key: PreferencesKeys.accessToken);
    await _secure.delete(key: PreferencesKeys.refreshToken);
  }

  static Future<void> setExpiresIn(int value) =>
      _box.put(PreferencesKeys.expiresIn, value);
  static int expiresIn() =>
      _box.get(PreferencesKeys.expiresIn, defaultValue: 0);

  static Future<void> setRefreshExpiresIn(int value) =>
      _box.put(PreferencesKeys.refreshExpiresIn, value);
  static int refreshExpiresIn() =>
      _box.get(PreferencesKeys.refreshExpiresIn, defaultValue: 0);

  static Future<void> setTokenObtainedAt(int value) =>
      _box.put(PreferencesKeys.tokenObtainedAt, value);
  static int tokenObtainedAt() =>
      _box.get(PreferencesKeys.tokenObtainedAt, defaultValue: 0);
}
