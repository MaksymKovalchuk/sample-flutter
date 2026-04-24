import 'package:injectable/injectable.dart';
import 'package:sample/src/core/network/api_model.dart';
import 'package:sample/src/core/network/constants/api_endpoints.dart';
import 'package:sample/src/core/network/constants/api_methods.dart';
import 'package:sample/src/core/network/constants/api_router.dart';
import 'package:sample/src/core/network/rest_client.dart';

@lazySingleton
class AuthRepository {
  AuthRepository(this._restClient);
  final RestClient _restClient;

  Future<dynamic> validateToken() async {
    final resp = await _restClient.request<dynamic>(
      bypassInitializer: true,
      apiModel: ApiModel(
        serviceType: ServiceType.main,
        method: Method.get,
        pathUrl: Requests.token,
      ),
    );

    return resp;
  }
}
