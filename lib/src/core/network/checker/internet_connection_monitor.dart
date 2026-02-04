import 'dart:async';
import 'package:sample/src/services/logging/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionMonitor extends ValueNotifier<bool> {
  InternetConnectionMonitor({
    InternetConnection? checker,
    this.onReconnect,
    this.reconnectDelay = const Duration(seconds: 1),
  })  : _checker = checker ?? InternetConnection(),
        super(true);

  final InternetConnection _checker;
  final VoidCallback? onReconnect;
  final Duration reconnectDelay;

  StreamSubscription<InternetStatus>? _subscription;
  Timer? _reconnectTimer;
  bool _hasInternet = true;
  bool _started = false;

  /// Start monitoring. Safe to call multiple times (no-op if already started).
  Future<void> start() async {
    if (_started) return;
    _started = true;

    // Initialize with current connectivity
    try {
      final connected = await _checker.hasInternetAccess;
      _hasInternet = connected;
      if (value != connected) value = connected;
    } catch (_) {
      // If probe fails, assume offline
      _hasInternet = false;
      if (value != false) value = false;
    }

    _subscription = _checker.onStatusChange.listen(
      (status) => _onStatus(status == InternetStatus.connected),
      onError: (e, st) {
        // On stream error assume offline, but do not crash
        if (value != false) value = false;
        _hasInternet = false;
        logger.error("InternetConnectionMonitor stream error",
            error: e, stackTrace: st);
      },
      cancelOnError: false,
    );
    logger.info("InternetConnectionMonitor started");
  }

  /// Stop monitoring and free resources.
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
    // If state truly changed
    if (!_hasInternet && connected) {
      // schedule reconnect confirmation; cancel older timer if any
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(reconnectDelay, () {
        // If still connected when timer fires
        if (_hasInternet) return; // already processed by a newer event
        _hasInternet = true;
        if (value != true) value = true;
        try {
          onReconnect?.call();
        } catch (e) {
          logger.error("onReconnect callback error", error: e);
        }
      });
    } else if (_hasInternet && !connected) {
      // going offline: cancel pending reconnect, emit immediately
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      _hasInternet = false;
      if (value != false) value = false;
    } else {
      // No effective transition; ignore
    }
  }
}
