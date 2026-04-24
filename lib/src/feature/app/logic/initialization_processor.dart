import 'package:package_info_plus/package_info_plus.dart';
import 'package:sample/src/core/caches/preferences.dart';
import 'package:sample/src/core/di/injection.dart';
import 'package:sample/src/feature/app/model/dependencies.dart';
import 'package:sample/src/services/logging/logger.dart';
import 'package:sample/src/services/notifications/notification_manager.dart';

/// Runs the one-shot initialization: DI container → dependency bundle.
final class InitializationProcessor {
  const InitializationProcessor();

  Future<InitializationResult> initialize() async {
    final stopwatch = Stopwatch()..start();

    logger.info('Initializing dependencies...');
    await configureDependencies();
    logger.info('Dependencies initialized');

    stopwatch.stop();

    return InitializationResult(
      dependencies: Dependencies(
        notifications: getIt<NotificationManager>(),
        preferences: getIt<Preferences>(),
        packageInfo: getIt<PackageInfo>(),
      ),
      msSpent: stopwatch.elapsedMilliseconds,
    );
  }
}
