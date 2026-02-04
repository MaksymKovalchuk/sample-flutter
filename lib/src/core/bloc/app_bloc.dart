import 'dart:async';
import 'package:sample/src/core/caches/preferences/preferences_token.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/core/network/token/token_provider.dart';
import 'package:sample/src/core/app_initializer/app_initializer.dart';
import 'package:sample/src/core/session/token_guard.dart';
import 'package:sample/src/core/session/session_manager.dart';
import 'package:sample/src/services/logging/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(
    this._initializer,
    this._tokenProvider,
    this._sessionManager,
  ) : super(const AuthUninitialized()) {
    on<AppStarted>(_onAppStartedEvent);
    on<LoggedIn>(_onLoggedInEvent);
    on<LoggedOut>(_onLoggedOutEvent);
  }

  final AppInitializer _initializer;
  final TokenProvider _tokenProvider;
  final SessionManager _sessionManager;

  bool isBannerVisible = false;

  // Handler for the AppStarted event.
  Future<void> _onAppStartedEvent(
    AppStarted event,
    Emitter<AppState> emit,
  ) async {
    final String? token = await TokenPreferences.accessToken();

    if (token != null && token.isNotEmpty) {
      try {
        await _initializeAfterLogin(emit);
      } on SessionExpiredException catch (e) {
        await _resetSession();
        emit(const AuthUnauthenticated());
        logger.warning("Session expired on app start: ${e.message}");
      } catch (e, stack) {
        logger.error("Unexpected error on AppStarted",
            error: e, stackTrace: stack);
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  // Handler for the LoggedIn event.
  Future<void> _onLoggedInEvent(
    LoggedIn event,
    Emitter<AppState> emit,
  ) async {
    emit(const AuthInProgress());

    final String? token = event.token;
    if (token != null) {
      await TokenPreferences.setAccessToken(token);
      _tokenProvider.clearCache();
    }

    try {
      await _initializeAfterLogin(emit);

      if (!(event.completer?.isCompleted ?? true)) {
        event.completer?.complete();
      }
    } catch (e, _) {
      logger.warning('Login initialization failed: $e');
      if (!(event.completer?.isCompleted ?? true)) {
        event.completer?.completeError(e);
      }
    }
  }

  Future<void> _initializeAfterLogin(Emitter<AppState> emit) async {
    TokenGuard.reset();
    await _initializer.initialize();
  }

  // Handler for the LoggedOut event.
  Future<void> _onLoggedOutEvent(
    LoggedOut event,
    Emitter<AppState> emit,
  ) async {
    emit(const AuthInProgress());
    try {
      isBannerVisible = false;

      await _resetSession();
      emit(const AuthUnauthenticated(loggedOut: true));
    } catch (error) {
      emit(LogoutFailure("$error"));
    }
  }

  Future<void> _resetSession() async {
    await _sessionManager.resetSession();
  }
}
