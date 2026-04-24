import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/services/logging/logger.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onTransition(
    Bloc<Object?, Object?> bloc,
    Transition<Object?, Object?> transition,
  ) {
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc<Object?, Object?> bloc, Object? event) {
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    logger.error(
      'Bloc: ${bloc.runtimeType} | $error',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
