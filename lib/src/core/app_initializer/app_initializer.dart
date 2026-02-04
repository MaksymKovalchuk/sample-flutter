import 'dart:async';
import 'package:sample/src/core/caches/preferences/preferences_token.dart';
import 'package:sample/src/core/di/locator.dart';
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

  /// Ensures one-time initialization; caches the result for concurrent callers.
  Future<void> initialize() => _initFuture ??= _initializeInternal();

  /// Core init logic: checks token presence, refreshes and validates it.
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
      await _tokenProvider.getValidAccessToken(); // refresh if needed

      logger.info("Validating token...");
      await _validateTokenWithRetries(); // retries in case of server flakiness

      _readyCompleter.complete();
    } on SessionExpiredException catch (e) {
      _handleInitError(e, customMessage: e.message);
      rethrow;
    } catch (e) {
      _handleInitError(e,
          customMessage: "Session expired. Please log in again.");
      rethrow;
    }
  }

  /// Validates token with limited retries (default: 3).
  Future<void> _validateTokenWithRetries({int retries = 3}) async {
    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        await _authRepository.validateToken();
        return;
      } catch (e) {
        logger.warning("validateToken attempt ${attempt + 1} failed: $e");
        if (attempt < retries - 1) {
          await Future.delayed(const Duration(seconds: 2));
        } else {
          throw SessionExpiredException("Access expired. Please log in again.");
        }
      }
    }
  }

  /// Handles errors and triggers logout if init fails.
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

  /// Resets state to allow re-initialization.
  void reset() {
    _isInitialized = false;
    if (_readyCompleter.isCompleted) _readyCompleter = Completer<void>();
    _initFuture = null;
  }
}
