import 'package:flutter/services.dart';
import 'package:sample/src/core/navigation/navigation_service.dart';

enum DeviceType { mobile, tablet }

class DeviceInfoService {
  const DeviceInfoService._();

  static const double _maxMobileWidth = 500;

  static DeviceType get deviceType {
    final width = globalContext?.size?.shortestSide ?? 0;
    return width > _maxMobileWidth ? DeviceType.tablet : DeviceType.mobile;
  }

  static Future<void> setPreferredOrientation() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
