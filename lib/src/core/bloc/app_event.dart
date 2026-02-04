part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
  @override
  List<Object> get props => [];
}

class AppStarted extends AppEvent {}

class LoggedIn extends AppEvent {
  const LoggedIn({required this.token, this.completer});
  final String? token;
  final Completer<void>? completer;
  @override
  List<Object> get props => [token!];
}

class LoggedOut extends AppEvent {}
