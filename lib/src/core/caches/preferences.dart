import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:sample/src/core/caches/preferences/preferences_keys.dart';
import 'package:sample/src/core/caches/preferences/preferences_token.dart';
import 'package:sample/src/core/di/locator.dart';

class Preferences {
  static Preferences get to => locator<Preferences>();

  final _secureStorage = const FlutterSecureStorage();
  FlutterSecureStorage get secureStorage => _secureStorage;

  static const _prefBox = PreferencesKeys.prefBox;
  static const _prefGlobalBox = PreferencesKeys.prefGlobalBox;

  Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox<dynamic>(_prefBox);
    await Hive.openBox<dynamic>(_prefGlobalBox);
  }

  Future<void> clearCache() async {
    await TokenPreferences.clearTokens();
    await Hive.box<dynamic>(_prefBox).clear();
  }

  Box<dynamic> get prefBox => Hive.box<dynamic>(_prefBox);
  Box<dynamic> get globalBox => Hive.box<dynamic>(_prefGlobalBox);
}
