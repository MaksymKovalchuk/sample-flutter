import 'package:flutter/foundation.dart';
import 'dart:io';

/// The environment the app is currently running in.
enum Environment {
  /// Development environment.
  dev,

  /// Production environment.
  prod,

  /// Production environment on simulator.
  prodSimulator;

  /// Returns the current environment.
  static Environment get() {
    if (kReleaseMode) {
      return isRunningInSimulator
          ? Environment.prodSimulator
          : Environment.prod;
    } else {
      return Environment.dev;
    }
  }

  /// Whether the app is running in a simulator/emulator.
  static bool get isRunningInSimulator =>
      !Platform.isAndroid && !Platform.isIOS;

  /// Returns `true` if environment is development.
  bool get isDev => this == Environment.dev;

  /// Returns `true` if environment is production.
  bool get isProd => this == Environment.prod;

  /// Returns `true` if environment is simulator in production mode.
  bool get isProdSimulator => this == Environment.prodSimulator;

  /// Returns a short string version of the environment name.
  String get short => toString().split('.').last;

  @override
  String toString() => 'Environment.$short';
}
