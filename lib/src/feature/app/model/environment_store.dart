import 'package:sample/src/feature/app/model/environment.dart';

/// Environment store
class EnvironmentStore {
  const EnvironmentStore();

  /// The Sentry DSN.
  String get sentryDsn => '';

  /// The environment.
  Environment get environment => Environment.get();

  /// Whether Sentry is enabled.
  bool get enableTrackingManager => sentryDsn.isNotEmpty;
}
