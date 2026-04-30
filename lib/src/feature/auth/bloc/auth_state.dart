import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sample/src/services/validators/input_validators.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isLoading,
    String? error,
  }) = _AuthState;

  const AuthState._();

  bool get isFormValid =>
      InputValidators.isValidEmail(email) && password.length >= 6;
}
