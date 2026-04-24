import 'dart:async';
import 'dart:ui';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sample/src/core/bloc/app_bloc_observer.dart';
import 'package:sample/src/feature/app/logic/initialization_processor.dart';
import 'package:sample/src/feature/app/widget/app.dart';
import 'package:sample/src/feature/app/widget/splash_error_app.dart';
import 'package:sample/src/services/logging/logger.dart';

/// Bootstraps the app: splash → error handling → BLoC → DI → App root.
final class AppRunner {
  const AppRunner();

  Future<void> initializeAndRun() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.deferFirstFrame();
    FlutterNativeSplash.preserve(widgetsBinding: binding);

    WidgetsBinding.instance.platformDispatcher.onError =
        logger.logPlatformDispatcherError;

    _setupErrorHandling();
    _setupBloc();

    try {
      final result = await const InitializationProcessor().initialize();
      App(result: result).attach(FlutterNativeSplash.remove);
    } catch (e, stackTrace) {
      logger.error('Initialization failed', error: e, stackTrace: stackTrace);
      runApp(
        SplashErrorApp(
          error: e,
          stackTrace: stackTrace,
          retryInitialization: initializeAndRun,
        ),
      );
    } finally {
      binding.allowFirstFrame();
    }
  }

  void _setupErrorHandling() {
    FlutterError.onError = logger.logFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      logger.error("Platform error", error: error, stackTrace: stack);
      return true;
    };
  }

  void _setupBloc() {
    Bloc.observer = const AppBlocObserver();
    Bloc.transformer = bloc_concurrency.sequential();
  }
}
