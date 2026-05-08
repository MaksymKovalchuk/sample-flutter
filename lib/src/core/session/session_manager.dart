import 'package:sample/src/core/network/token/token_provider.dart';
import 'package:sample/src/core/session/app_initializer.dart';
import 'package:sample/src/services/logging/logger.dart';

class SessionManager {
  const SessionManager({
    required AppInitializer initializer,
    required TokenProvider tokenProvider,
  }) : _initializer = initializer,
       _tokenProvider = tokenProvider;

  final AppInitializer _initializer;
  final TokenProvider _tokenProvider;

  // in-memory only — LogoutManager.logout() owns storage clearing
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
  }
}
