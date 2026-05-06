import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:sample/src/core/caches/preferences/preferences_token.dart';
import 'package:sample/src/core/network/constants/api_endpoints.dart';
import 'package:sample/src/core/network/constants/api_keys.dart';
import 'package:sample/src/core/network/constants/api_router.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/services/logging/logger.dart';

@lazySingleton
class TokenProvider {
  TokenProvider(this._client);
  final http.Client _client;

  String? _cachedAccessToken;
  Completer<String>? _refreshCompleter;
  bool _recoveryFailed = false;

  bool validatingInProgress = true;

  // true after refresh fails — caller must trigger re-login
  bool get isRecoveryFailed => _recoveryFailed;

  void _markRecoveryFailed() {
    if (!_recoveryFailed) {
      logger.warning("🔐 Token refresh marked as failed");
    }
    _recoveryFailed = true;
  }

  void resetRecovery() {
    _recoveryFailed = false;
  }

  Future<String> getValidAccessToken() async {
    if (_recoveryFailed) {
      logger.warning("Token recovery failed — blocking getValidAccessToken");
      throw SessionExpiredException();
    }

    if (await isTokenExpired()) return _refreshAccessTokenSafely();

    final cached = _cachedAccessToken;
    if (cached != null) return cached;

    final token = await TokenPreferences.accessToken();
    if (token == null || token.isEmpty) throw Exception("Token missing.");

    _cachedAccessToken = token;
    return token;
  }

  Future<String> _refreshAccessTokenSafely() async {
    if (_refreshCompleter != null) return _refreshCompleter!.future;

    _refreshCompleter = Completer();
    try {
      final token = await _refreshAccessToken();
      _refreshCompleter!.complete(token);
      return token;
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<String> _refreshAccessToken() async {
    logger.info("🔄 RefreshToken run...");

    final refreshToken = await TokenPreferences.refreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      logger.warning("No refresh token found");
      throw SessionExpiredException();
    }

    final resp = await authTokenRequest({
      'grant_type': 'refresh_token',
      'client_id': '',
      'refresh_token': refreshToken,
    });

    final tokenValue = resp[Keys.token];
    if (tokenValue is! String || tokenValue.isEmpty) {
      logger.error("Invalid token response: $resp");
      throw Exception("Token response is missing required fields.");
    }

    final tokenType = resp['token_type'] is String
        ? resp['token_type'] as String
        : 'Bearer';

    final accessToken = '$tokenType $tokenValue';
    _cachedAccessToken = accessToken;

    await TokenPreferences.setAccessToken(accessToken);
    await saveTokenData(resp);

    logger.info("🔄 RefreshToken done...");

    return accessToken;
  }

  Future<bool> isTokenExpired() async {
    final obtainedAt = TokenPreferences.tokenObtainedAt();
    final expiresIn = TokenPreferences.expiresIn();
    if (obtainedAt == 0 || expiresIn == 0) return true;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    return currentTime > (obtainedAt + expiresIn * 1000);
  }

  Future<void> saveTokenData(Map<String, dynamic> data) async {
    final refreshToken = data['refresh_token'] as String? ?? '';
    final expiresIn = data['expires_in'] as int? ?? 0;
    final refreshExpiresIn = data['refresh_expires_in'] as int? ?? 0;

    await TokenPreferences.setRefreshToken(refreshToken);
    await TokenPreferences.setExpiresIn(expiresIn);
    await TokenPreferences.setRefreshExpiresIn(refreshExpiresIn);
    await TokenPreferences.setTokenObtainedAt(
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<Map<String, dynamic>> authTokenRequest(
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse(
      "${ApiRouter.getRestUrl(ServiceType.main)}${Requests.token}",
    );

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (response.statusCode == 200) {
      validatingInProgress = false;
      return json.decode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode == 400) {
      final errorBody = json.decode(response.body) as Map<String, dynamic>;
      final error = errorBody['error'] as String?;
      final errorDesc = errorBody['error_description'] as String?;

      if (error == 'invalid_grant' &&
          (errorDesc?.contains('Token is not active') ?? false)) {
        _markRecoveryFailed();
        throw SessionExpiredException();
      }
    }

    _markRecoveryFailed();
    throw SessionExpiredException();
  }

  void clearCache() {
    validatingInProgress = true;
    _cachedAccessToken = null;
  }
}
