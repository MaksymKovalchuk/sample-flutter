import 'package:sample/src/core/di/locator.dart';
import 'package:sample/src/core/models/hive_models/profile_history.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'preferences/preferences_keys.dart';
import 'preferences/preferences_token.dart';

class Preferences {
  static Preferences get to => locator<Preferences>();

  final _secureStorage = const FlutterSecureStorage();
  FlutterSecureStorage get secureStorage => _secureStorage;

  /// Main boxes
  static const _prefBox = PreferencesKeys.prefBox;
  static const _prefGlobalBox = PreferencesKeys.prefGlobalBox;

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter<CacheProfileModel>(CacheProfileModelAdapter());

    await Hive.openBox(_prefBox);
    await Hive.openBox(_prefGlobalBox);
  }

  /// Clear all local cache
  Future<void> clearCache() async {
    await TokenPreferences.clearTokens();
    await Hive.box(_prefBox).clear();
  }

  /// Boxes API
  Box get prefBox => Hive.box(_prefBox);
  Box get globalBox => Hive.box(_prefGlobalBox);
}
