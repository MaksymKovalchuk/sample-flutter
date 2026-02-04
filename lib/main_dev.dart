import 'dart:async';
import 'package:sample/src/services/logging/logger.dart';
import 'package:sample/src/feature/app/logic/app_runner.dart';
import 'src/services/helpers/print_suppressor.dart';

void main() {
  final zone = PrintSuppressor.zoneSpec();
  logger.runLogging(
    () => runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      zoneSpecification: zone,
      logger.logZoneError,
    ),
    const LogOptions(),
  );
}
