import 'dart:async';

import 'package:sample/src/feature/app/logic/app_runner.dart';
import 'package:sample/src/services/helpers/print_suppressor.dart';
import 'package:sample/src/services/logging/logger.dart';

void main() {
  final zone = PrintSuppressor.zoneSpec();
  logger.runLogging(
    () => runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      logger.logZoneError,
      zoneSpecification: zone,
    ),
  );
}
