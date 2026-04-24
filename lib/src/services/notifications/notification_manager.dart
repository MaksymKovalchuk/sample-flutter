import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationManager {
  NotificationManager()
    : navigatorKey = GlobalKey<NavigatorState>(),
      _plugin = _buildPlugin();

  final GlobalKey<NavigatorState> navigatorKey;
  final FlutterLocalNotificationsPlugin _plugin;

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  static FlutterLocalNotificationsPlugin _buildPlugin() {
    final plugin = FlutterLocalNotificationsPlugin();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/app_icon'),
      iOS: DarwinInitializationSettings(),
    );
    plugin.initialize(settings);
    return plugin;
  }
}
