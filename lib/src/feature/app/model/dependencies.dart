import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sample/src/core/caches/preferences.dart';
import 'package:sample/src/services/notifications/notification_manager.dart';

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

final class InitializationResult {
  const InitializationResult({
    required this.dependencies,
    required this.msSpent,
  });

  final Dependencies dependencies;
  final int msSpent;

  @override
  String toString() =>
      '$InitializationResult('
      'dependencies: $dependencies, '
      'msSpent: $msSpent'
      ')';
}
