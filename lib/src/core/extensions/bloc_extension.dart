import 'package:sample/src/services/logging/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocSafeAddExtension<E, S> on Bloc<E, S> {
  void safeAdd(E event) {
    if (isClosed) {
      logger.info('Bloc is closed, skipping event: $event');
      return;
    }

    try {
      add(event);
    } catch (e) {
      logger.info('safeAdd failed in $runtimeType: $event, error: $e');
    }
  }
}
