import 'package:sample/src/core/env/env.dart';
import 'package:sample/src/core/network/constants/api_keys.dart';

enum ServiceType { portal, main }

class ApiRouter {
  const ApiRouter._();

  static String getRestUrl(ServiceType type) {
    switch (type) {
      case ServiceType.portal:
        return "${Env.apiPortalUrl}${Keys.version}";
      case ServiceType.main:
        return Env.apiMainUrl;
    }
  }
}
