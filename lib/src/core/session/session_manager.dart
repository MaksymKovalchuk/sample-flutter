import 'package:sample/src/core/app_initializer/app_initializer.dart';
import 'package:sample/src/core/network/token/token_provider.dart';
import 'package:sample/src/core/session/logout_manager.dart';
import 'package:sample/src/services/logging/logger.dart';

class SessionManager {
  const SessionManager({
    required AppInitializer initializer,
    required TokenProvider tokenProvider,
    required LogoutManager logoutManager,
  })  : _initializer = initializer,
        _tokenProvider = tokenProvider,
        _logoutManager = logoutManager;

  final AppInitializer _initializer;
  final TokenProvider _tokenProvider;
  final LogoutManager _logoutManager;

  Future<void> resetSession() async {
    try {
      _initializer.reset();
    } catch (e) {
      logger.warning('Initializer reset failed: $e');
    }

    try {
      _tokenProvider.clearCache();
    } catch (e) {
      logger.warning('TokenProvider clearCache failed: $e');
    }

    try {
      await _logoutManager.clearData();
    } catch (e) {
      logger.warning('LogoutManager clearData failed: $e');
    }
  }
}
