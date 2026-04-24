import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', allowOptionalFields: true)
abstract class Env {
  @EnviedField(varName: 'API_MAIN_URL', defaultValue: '')
  static const String apiMainUrl = _Env.apiMainUrl;

  @EnviedField(varName: 'API_PORTAL_URL', defaultValue: '')
  static const String apiPortalUrl = _Env.apiPortalUrl;

  @EnviedField(varName: 'SENTRY_DSN', defaultValue: '')
  static const String sentryDsn = _Env.sentryDsn;
}
