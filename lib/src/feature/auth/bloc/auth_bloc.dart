import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/core/network/rest/repositories/login_repository.dart';
import 'package:sample/src/feature/auth/bloc/auth_event.dart';
import 'package:sample/src/feature/auth/bloc/auth_state.dart';
import 'package:sample/src/services/logging/logger.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._loginRepository, this._initialBloc) : super(const AuthIdle()) {
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthLoginSubmitted>(_onLoginSubmitted, transformer: droppable());
  }

  final LoginRepository _loginRepository;
  final AppBloc _initialBloc;

  void _onEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    final s = state;
    if (s is AuthIdle) {
      emit(s.copyWith(email: event.email.trim(), clearError: true));
    }
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    final s = state;
    if (s is AuthIdle) {
      emit(s.copyWith(password: event.password, clearError: true));
    }
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final current = state;
    if (current is! AuthIdle || !current.isFormValid) return;

    final email = current.email;
    final password = current.password;

    emit(const AuthSubmitting());

    try {
      final token = await _loginRepository.login(
        email: email,
        password: password,
      );

      final completer = Completer<void>();
      _initialBloc.add(LoggedIn(token: token, completer: completer));
      await completer.future;
      // no success-state emit — page is disposed by router redirect
    } on ApiException catch (e) {
      logger.warning('Login failed: ${e.message}');
      emit(AuthIdle(email: email, password: password, error: e.message));
    } catch (e, stack) {
      logger.error('Unexpected login error', error: e, stackTrace: stack);
      emit(
        AuthIdle(
          email: email,
          password: password,
          error: 'Something went wrong',
        ),
      );
    }
  }
}
