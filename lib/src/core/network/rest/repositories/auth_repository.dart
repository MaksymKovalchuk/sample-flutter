import 'package:injectable/injectable.dart';
import 'package:sample/src/core/network/rest_client.dart';

@lazySingleton
class AuthRepository {
  AuthRepository(this._restClient);
  // ignore: unused_field
  final RestClient _restClient;

  // Demo stub: real implementation should hit a /me or /validate endpoint
  // and throw SessionExpiredException on 401. See AppInitializer for caller.
  Future<void> validateToken() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}
