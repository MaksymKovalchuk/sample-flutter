import 'dart:async';
import 'dart:convert';
import 'package:sample/src/core/caches/preferences/preferences_token.dart';
import 'package:sample/src/core/network/constants/api_endpoints.dart';
import 'package:sample/src/core/network/constants/api_keys.dart';
import 'package:sample/src/core/network/constants/api_router.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/core/session/token_guard.dart';
import 'package:sample/src/services/logging/logger.dart';
import 'package:http/http.dart' as http;

class TokenProvider {
  TokenProvider(this._client);
  final http.Client _client;

  String? _cachedAccessToken;

  Completer<String>? _refreshCompleter;

  bool validatingInProgress = true;

  Future<String> getValidAccessToken() async {
    if (TokenGuard.tokenRecoveryFailed) {
      logger.warning("TokenGuard blocked getValidAccessToken");
      throw SessionExpiredException();
    }

    if (await isTokenExpired()) return _refreshAccessTokenSafely();

    if (_cachedAccessToken != null) return _cachedAccessToken!;
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

    const tokenType = null;
    final tokenValue = resp[Keys.token];

    if (tokenType == null || tokenValue == null) {
      logger.error("Invalid token response: $resp");
      throw Exception("Token response is missing required fields.");
    }

    final accessToken = [tokenType, tokenValue].whereType<String>().join(' ');
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
    await TokenPreferences.setRefreshToken(data['refresh_token']);
    await TokenPreferences.setExpiresIn(data['expires_in']);
    await TokenPreferences.setRefreshExpiresIn(data['refresh_expires_in']);
    await TokenPreferences.setTokenObtainedAt(
        DateTime.now().millisecondsSinceEpoch);
  }

  Future<Map<String, dynamic>> authTokenRequest(
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse(
        "${ApiRouter.getRestUrl(ServiceType.main, envType)}${Requests.token}");

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (response.statusCode == 200) {
      validatingInProgress = false;
      return json.decode(response.body);
    }

    if (response.statusCode == 400) {
      final errorBody = json.decode(response.body);
      final error = errorBody['error'];
      final errorDesc = errorBody['error_description'];

      if (error == 'invalid_grant' &&
          errorDesc.contains('Token is not active')) {
        TokenGuard.markInvalid();
        throw SessionExpiredException();
      }
    }

    TokenGuard.markInvalid();
    throw SessionExpiredException();
  }

  void clearCache() {
    validatingInProgress = true;
    _cachedAccessToken = null;
  }
}
