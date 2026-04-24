import 'package:flutter/services.dart';
import 'package:sample/src/core/navigation/navigation_service.dart';

enum DeviceType { mobile, tablet }

class DeviceInfoService {
  const DeviceInfoService._();

  static const double _maxMobileWidth = 500;

  /// Determines the current device type based on screen width.
  static DeviceType get deviceType {
    final width = globalContext?.size?.shortestSide ?? 0;
    return width > _maxMobileWidth ? DeviceType.tablet : DeviceType.mobile;
  }

  /// Applies preferred screen orientation based on the device type.
  static Future<void> setPreferredOrientation() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
