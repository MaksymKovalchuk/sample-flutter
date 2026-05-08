import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/core/network/rest_client.dart';
import 'package:sample/src/core/network/token/token_provider.dart';

class LoginRepository {
  LoginRepository(this._restClient, this._tokenProvider);
  // ignore: unused_field
  final RestClient _restClient;
  final TokenProvider _tokenProvider;

  // stub — fake token + fake expiry; replace with real /auth/login + saveTokenData
  Future<String> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (email.isEmpty || password.isEmpty) {
      throw ApiException('Email and password are required');
    }

    await _tokenProvider.saveTokenData(<String, dynamic>{
      'refresh_token': 'demo-refresh',
      'expires_in': 3600, // 1 hour — long enough for demo session
      'refresh_expires_in': 86400,
    });

    return 'Bearer demo-${DateTime.now().millisecondsSinceEpoch}';
  }
}
