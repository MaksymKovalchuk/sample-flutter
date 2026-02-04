import 'package:sample/src/core/network/constants/api_keys.dart';

enum EnvType { dev, qa, prod }

enum ServiceType { portal, main }

EnvType envType = EnvType.qa;

class ApiRouter {
  const ApiRouter._();

  static const Map<EnvType, String> keycloak = {
    EnvType.dev: "https://users",
    EnvType.qa: "https://users",
    EnvType.prod: "",
  };

  static const Map<EnvType, String> portal = {
    EnvType.dev: "https://api/",
    EnvType.qa: "https://api/",
    EnvType.prod: "",
  };

  static const Map<EnvType, String> wsCgate = {
    EnvType.dev: "wss://net",
    EnvType.qa: "wss://net",
    EnvType.prod: "",
  };

  static const Map<EnvType, String> wsTradingmain = {
    EnvType.dev: "wss://net",
    EnvType.qa: "wss://net",
    EnvType.prod: "",
  };

  static String getRestUrl(ServiceType type, EnvType env) {
    switch (type) {
      case ServiceType.portal:
        return "${portal[env]}${Keys.version}";
      case ServiceType.main:
        return keycloak[env] ?? '';
    }
  }

  static String getWsUrl(ServiceType type, EnvType env) {
    switch (type) {
      case ServiceType.portal:
        return wsCgate[env] ?? '';
      case ServiceType.main:
        return wsTradingmain[env] ?? '';
    }
  }
}
