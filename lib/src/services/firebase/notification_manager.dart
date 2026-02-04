import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  NotificationManager({
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
    core = FirebaseNotificationHandler(_navigatorKey);
  }
  late GlobalKey<NavigatorState> _navigatorKey;
  late FirebaseNotificationHandler core;

  GlobalKey<NavigatorState> getNavigatorKey() => _navigatorKey;
}

class FirebaseNotificationHandler {
  FirebaseNotificationHandler(GlobalKey<NavigatorState> navigatorKey) {
    _initializeNotificationsPlugin();
  }
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  void _initializeNotificationsPlugin() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings("@drawable/app_icon");
    const initializationSettingsIOS = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _saveDeviceToken();
  }

  Future<void> _saveDeviceToken() async {}
}
