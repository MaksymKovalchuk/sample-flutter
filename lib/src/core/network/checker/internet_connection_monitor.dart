import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sample/src/services/logging/logger.dart';

class InternetConnectionMonitor extends ValueNotifier<bool> {
  InternetConnectionMonitor({
    InternetConnection? checker,
    this.onReconnect,
    this.reconnectDelay = const Duration(seconds: 1),
  }) : _checker = checker ?? InternetConnection(),
       super(true);

  final InternetConnection _checker;
  final VoidCallback? onReconnect;
  final Duration reconnectDelay;

  StreamSubscription<InternetStatus>? _subscription;
  Timer? _reconnectTimer;
  bool _hasInternet = true;
  bool _started = false;

  // idempotent
  Future<void> start() async {
    if (_started) return;
    _started = true;

    try {
      final connected = await _checker.hasInternetAccess;
      _hasInternet = connected;
      if (value != connected) value = connected;
    } catch (_) {
      // probe failed → assume offline
      _hasInternet = false;
      if (value != false) value = false;
    }

    _subscription = _checker.onStatusChange.listen(
      (status) => _onStatus(status == InternetStatus.connected),
      onError: (Object e, StackTrace st) {
        // stream error → assume offline, don't crash
        if (value != false) value = false;
        _hasInternet = false;
        logger.error(
          "InternetConnectionMonitor stream error",
          error: e,
          stackTrace: st,
        );
      },
      cancelOnError: false,
    );
    logger.info("InternetConnectionMonitor started");
  }

  void stop() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _started = false;
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  void _onStatus(bool connected) {
    if (!_hasInternet && connected) {
      // debounce reconnect — cancel any older pending timer
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(reconnectDelay, () {
        if (_hasInternet) return; // already handled by newer event
        _hasInternet = true;
        if (value != true) value = true;
        try {
          onReconnect?.call();
        } catch (e) {
          logger.error("onReconnect callback error", error: e);
        }
      });
    } else if (_hasInternet && !connected) {
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      _hasInternet = false;
      if (value != false) value = false;
    }
  }
}
