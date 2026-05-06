import 'package:injectable/injectable.dart';
import 'package:sample/src/core/network/rest_client.dart';

@lazySingleton
class AuthRepository {
  AuthRepository(this._restClient);
  // ignore: unused_field
  final RestClient _restClient;

  // stub — wire up real /me when backend is ready
  Future<void> validateToken() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}
