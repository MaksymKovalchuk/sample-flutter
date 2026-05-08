import 'package:equatable/equatable.dart';
import 'package:sample/src/services/validators/input_validators.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthIdle extends AuthState {
  const AuthIdle({this.email = '', this.password = '', this.error});

  final String email;
  final String password;
  final String? error;

  bool get isFormValid =>
      InputValidators.isValidEmail(email) && password.length >= 6;

  AuthIdle copyWith({
    String? email,
    String? password,
    String? error,
    bool clearError = false,
  }) => AuthIdle(
    email: email ?? this.email,
    password: password ?? this.password,
    error: clearError ? null : (error ?? this.error),
  );

  @override
  List<Object?> get props => [email, password, error];
}

final class AuthSubmitting extends AuthState {
  const AuthSubmitting();

  @override
  List<Object?> get props => const [];
}
