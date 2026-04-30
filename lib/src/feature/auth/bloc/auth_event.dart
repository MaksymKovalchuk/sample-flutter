sealed class AuthEvent {
  const AuthEvent();
}

final class AuthEmailChanged extends AuthEvent {
  const AuthEmailChanged(this.email);
  final String email;
}

final class AuthPasswordChanged extends AuthEvent {
  const AuthPasswordChanged(this.password);
  final String password;
}

final class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted();
}
