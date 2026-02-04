import 'package:sample/src/services/logging/logger.dart';
import 'dart:async';
import 'package:sample/src/feature/app/logic/app_runner.dart';

void main() {
  logger.runLogging(
    () => runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      logger.logZoneError,
    ),
    const LogOptions(),
  );
}
