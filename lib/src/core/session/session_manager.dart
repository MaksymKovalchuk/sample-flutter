import 'package:injectable/injectable.dart';
import 'package:sample/src/core/network/token/token_provider.dart';
import 'package:sample/src/core/session/app_initializer.dart';
import 'package:sample/src/services/logging/logger.dart';

@lazySingleton
class SessionManager {
  const SessionManager({
    required AppInitializer initializer,
    required TokenProvider tokenProvider,
  }) : _initializer = initializer,
       _tokenProvider = tokenProvider;

  final AppInitializer _initializer;
  final TokenProvider _tokenProvider;

  /// Resets in-memory bloc-level state. Persistent storage clearing is the
  /// responsibility of [LogoutManager.logout] (called from the UI). Calling
  /// LogoutManager.clearData here would be a duplicate clear during the
  /// LogoutManager → AppBloc.LoggedOut → SessionManager.resetSession chain.
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
