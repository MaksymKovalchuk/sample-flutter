import 'package:sample/src/services/logging/logger.dart';

class TokenGuard {
  const TokenGuard._();

  static bool tokenRecoveryFailed = false;

  static void markInvalid() {
    if (!tokenRecoveryFailed) {
      logger.warning("🔐 TokenGuard: token refresh marked as failed");
    }
    tokenRecoveryFailed = true;
  }

  static void reset() {
    tokenRecoveryFailed = false;
  }
}
