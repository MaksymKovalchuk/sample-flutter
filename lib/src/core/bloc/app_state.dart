part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AppState {
  const AuthUninitialized();
}

class AuthInProgress extends AppState {
  const AuthInProgress();
}

class AuthUnauthenticated extends AppState {
  const AuthUnauthenticated({this.loggedOut = false});
  final bool loggedOut;
  @override
  List<Object> get props => [loggedOut];
}

class LogoutFailure extends AppState {
  const LogoutFailure(this.message, {Object? id})
      : id = id ?? const Object(),
        super();
  final String message;
  final Object id;
  @override
  List<Object> get props => [message, id];
}
