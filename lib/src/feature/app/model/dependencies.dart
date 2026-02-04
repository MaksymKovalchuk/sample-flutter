import 'package:sample/src/core/caches/preferences.dart';
import 'package:sample/src/services/firebase/notification_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Dependencies container
@immutable
base class Dependencies {
  const Dependencies({
    required this.notifications,
    required this.preferences,
    required this.packageInfo,
  });

  final NotificationManager notifications;
  final Preferences preferences;
  final PackageInfo packageInfo;

  @override
  String toString() => '$packageInfo';
}

/// Result of initialization
final class InitializationResult {
  const InitializationResult({
    required this.dependencies,
    required this.msSpent,
  });

  /// The dependencies
  final Dependencies dependencies;

  /// The number of milliseconds spent
  final int msSpent;

  @override
  String toString() => '$InitializationResult('
      'dependencies: $dependencies, '
      'msSpent: $msSpent'
      ')';
}
