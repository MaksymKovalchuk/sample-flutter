import 'package:sample/src/core/caches/preferences.dart';
import 'package:sample/src/core/di/locator.dart';
import 'package:sample/src/services/firebase/notification_manager.dart';
import 'package:sample/src/services/logging/logger.dart';
import 'package:sample/src/feature/app/logic/tracking_manager.dart';
import 'package:sample/src/feature/app/model/dependencies.dart';
import 'package:sample/src/feature/app/model/environment.dart';
import 'package:sample/src/feature/app/model/environment_store.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'initialization_factory.dart';

/// A class which is responsible for processing initialization steps.
final class InitializationProcessor {
  const InitializationProcessor({
    required ExceptionTrackingManager trackingManager,
    required EnvironmentStore environmentStore,
  })  : _trackingManager = trackingManager,
        _environmentStore = environmentStore;
  final ExceptionTrackingManager _trackingManager;
  final EnvironmentStore _environmentStore;

  Future<Dependencies> _initDependencies() async {
    await setupLocator();

    return Dependencies(
      notifications: locator<NotificationManager>(),
      preferences: locator<Preferences>(),
      packageInfo: locator<PackageInfo>(),
    );
  }

  /// Method that starts the initialization process
  /// and returns the result of the initialization.
  ///
  /// This method may contain additional steps that need initialization
  /// before the application starts
  Future<InitializationResult> initialize() async {
    final environment = _environmentStore.environment;

    if (environment == Environment.dev ||
        environment == Environment.prodSimulator) {
      await _trackingManager.disableReporting();
    } else {
      await _trackingManager.enableReporting();
    }

    final stopwatch = Stopwatch()..start();

    logger.info('Initializing dependencies...');
    final dependencies = await _initDependencies();
    logger.info('Dependencies initialized');

    stopwatch.stop();

    return InitializationResult(
      dependencies: dependencies,
      msSpent: stopwatch.elapsedMilliseconds,
    );
  }
}
