import 'dart:async';
import 'dart:ui';
import 'package:sample/src/core/bloc/app_bloc_observer.dart';
import 'package:sample/src/services/logging/logger.dart';
import 'package:sample/src/feature/app/logic/initialization_processor.dart';
import 'package:sample/src/feature/app/widget/app.dart';
import 'package:sample/src/feature/app/widget/initialization_failed_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter_native_splash/flutter_native_splash.dart';

/// A class which is responsible for initialization and running the app.
final class AppRunner with InitializationFactoryImpl {
  const AppRunner();

  /// Start the initialization and in case of success run application
  Future<void> initializeAndRun() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    // Preserve splash screen
    binding.deferFirstFrame();
    FlutterNativeSplash.preserve(widgetsBinding: binding);
    // Override logging
    WidgetsBinding.instance.platformDispatcher.onError =
        logger.logPlatformDispatcherError;

    _setupErrorHandling();
    _setupBloc();

    final environmentStore = getEnvironmentStore();
    final initializationProcessor = InitializationProcessor(
      trackingManager: createTrackingManager(environmentStore),
      environmentStore: environmentStore,
    );

    try {
      final result = await initializationProcessor.initialize();

      // Attach this widget to the root of the tree.
      App(result: result).attach(FlutterNativeSplash.remove);
    } catch (e, stackTrace) {
      logger.error('Initialization failed', error: e, stackTrace: stackTrace);

      runApp(
        InitializationFailedApp(
          error: e,
          stackTrace: stackTrace,
          retryInitialization: initializeAndRun,
        ),
      );
    } finally {
      // Allow rendering
      binding.allowFirstFrame();
    }
  }

  void _setupErrorHandling() {
    FlutterError.onError = (errorDetails) {
      logger.logFlutterError(errorDetails);
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      logger.error("Platform error", error: error, stackTrace: stack);
      return true;
    };
  }

  // Setup bloc observer and transformer
  void _setupBloc() {
    Bloc.observer = const AppBlocObserver();
    Bloc.transformer = bloc_concurrency.sequential();
  }
}
