import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/core/network/rest/repositories/login_repository.dart';
import 'package:sample/src/feature/auth/bloc/auth_event.dart';
import 'package:sample/src/feature/auth/bloc/auth_state.dart';
import 'package:sample/src/services/logging/logger.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._loginRepository, this._appBloc) : super(const AuthState()) {
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthLoginSubmitted>(_onLoginSubmitted, transformer: droppable());
  }

  final LoginRepository _loginRepository;
  final AppBloc _appBloc;

  void _onEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(email: event.email.trim(), error: null));
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(password: event.password, error: null));
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.isFormValid || state.isLoading) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final token = await _loginRepository.login(
        email: state.email,
        password: state.password,
      );

      final completer = Completer<void>();
      _appBloc.add(LoggedIn(token: token, completer: completer));
      await completer.future;
    } on ApiException catch (e) {
      logger.warning('Login failed: ${e.message}');
      emit(state.copyWith(isLoading: false, error: e.message));
    } catch (e, stack) {
      logger.error('Unexpected login error', error: e, stackTrace: stack);
      emit(state.copyWith(isLoading: false, error: 'Something went wrong'));
    }
  }
}
