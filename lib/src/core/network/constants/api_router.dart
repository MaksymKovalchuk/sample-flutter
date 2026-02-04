import 'package:sample/src/core/network/constants/api_keys.dart';

enum EnvType { dev, qa, prod }

enum ServiceType { portal, main }

EnvType envType = EnvType.qa; // Move this to config in the future

class ApiRouter {
  const ApiRouter._();

  static const Map<EnvType, String> main = {
    EnvType.dev: "https://api/dev/main",
    EnvType.qa: "https://api/qa/main",
    EnvType.prod: "",
  };

  static const Map<EnvType, String> portal = {
    EnvType.dev: "https://api/dev/portal",
    EnvType.qa: "https://api/qa/portal",
    EnvType.prod: "",
  };

  static String getRestUrl(ServiceType type, EnvType env) {
    switch (type) {
      case ServiceType.portal:
        return "${portal[env]}${Keys.version}";
      case ServiceType.main:
        return main[env] ?? '';
    }
  }
}
