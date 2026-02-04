import 'package:sample/src/core/network/core/rest_client.dart';
import 'package:sample/src/core/network/core/api_model.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/api_methods.dart';
import '../../constants/api_router.dart';

class AuthRepository {
  AuthRepository(this._restClient);
  final RestClient _restClient;

  Future validateToken() async {
    final resp = await _restClient.request(
        bypassInitializer: true,
        apiModel: ApiModel(
          serviceType: ServiceType.main,
          method: Method.get,
          pathUrl: Requests.token,
        ));

    return resp;
  }
}
