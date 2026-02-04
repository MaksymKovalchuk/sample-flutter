part of 'initialization_processor.dart';

abstract class InitializationFactory {
  /// Get the environment store.
  EnvironmentStore getEnvironmentStore();

  /// Create a tracking manager.
  ExceptionTrackingManager createTrackingManager(
    EnvironmentStore environmentStore,
  );
}

mixin InitializationFactoryImpl implements InitializationFactory {
  @override
  SentryTrackingManager createTrackingManager(
    EnvironmentStore environmentStore,
  ) =>
      SentryTrackingManager(
        logger,
        environment: environmentStore.environment.name,
        sentryDsn: environmentStore.sentryDsn,
      );

  @override
  EnvironmentStore getEnvironmentStore() => const EnvironmentStore();
}
