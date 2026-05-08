import 'dart:async';

import 'package:sample/src/core/caches/preferences/preferences_token.dart';
import 'package:sample/src/core/di/injection.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/core/network/rest/repositories/auth_repository.dart';
import 'package:sample/src/core/network/token/token_provider.dart';
import 'package:sample/src/core/session/logout_manager.dart';
import 'package:sample/src/services/logging/logger.dart';

class AppInitializer {
  AppInitializer(this._authRepository, this._tokenProvider);
  final AuthRepository _authRepository;
  final TokenProvider _tokenProvider;

  Completer<void> _readyCompleter = Completer<void>();
  bool _isInitialized = false;

  Future<void>? _initFuture;

  Future<void> get ready => _readyCompleter.future;
  bool get isReady => _readyCompleter.isCompleted;

  Future<void> initialize() => _initFuture ??= _initializeInternal();

  Future<void> _initializeInternal() async {
    if (_isInitialized || _readyCompleter.isCompleted) return;

    final token = await TokenPreferences.accessToken();
    if (token == null || token.isEmpty) {
      logger.warning("AppInitializer: No access token found.");
      return;
    }

    _isInitialized = true;

    try {
      logger.info("Getting valid token...");
      await _tokenProvider.getValidAccessToken();

      logger.info("Validating token...");
      await _validateTokenWithRetries();

      _readyCompleter.complete();
    } on SessionExpiredException catch (e) {
      unawaited(_handleInitError(e, customMessage: e.message));
      rethrow;
    } catch (e) {
      unawaited(
        _handleInitError(
          e,
          customMessage: "Session expired. Please log in again.",
        ),
      );
      rethrow;
    }
  }

  Future<void> _validateTokenWithRetries({int retries = 3}) async {
    for (var attempt = 0; attempt < retries; attempt++) {
      try {
        await _authRepository.validateToken();
        return;
      } catch (e) {
        logger.warning("validateToken attempt ${attempt + 1} failed: $e");
        if (attempt < retries - 1) {
          await Future<void>.delayed(const Duration(seconds: 2));
        } else {
          throw SessionExpiredException("Access expired. Please log in again.");
        }
      }
    }
  }

  Future<void> _handleInitError(
    Object error, {
    required String customMessage,
  }) async {
    if (!_readyCompleter.isCompleted) {
      _readyCompleter.completeError(error);
    }

    logger.error("AppInitializer failed", error: error);
    await locator<LogoutManager>().logout(
      message: customMessage,
      source: 'AppInitializer',
    );
  }

  void reset() {
    _isInitialized = false;
    if (_readyCompleter.isCompleted) _readyCompleter = Completer<void>();
    _initFuture = null;
  }
}
