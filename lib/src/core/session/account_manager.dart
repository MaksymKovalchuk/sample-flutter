import 'dart:async';
import 'package:sample/src/services/logging/logger.dart';

class AccountManager {
  String? _accountId;
  Completer<void> _readyCompleter = Completer<void>();

  bool get isReady => _readyCompleter.isCompleted;

  String? get accountId => _accountId;

  void setAccountId(String id) {
    _accountId = id;
    logger.info("Account ID: $_accountId");
    if (!_readyCompleter.isCompleted) {
      _readyCompleter.complete();
    }
  }

  Future<void> get ready async {
    if (_accountId != null) return;
    return _readyCompleter.future;
  }

  Future<String?> requireAccountId() async {
    if (_accountId != null) return _accountId;
    await ready;
    return _accountId;
  }

  void clear() {
    _accountId = null;
    if (_readyCompleter.isCompleted) {
      _readyCompleter = Completer<void>();
    }
    logger.info("AccountManager: cleared accountId");
  }
}
