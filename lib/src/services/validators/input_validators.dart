class InputValidators {
  const InputValidators._();

  static final RegExp _emailPattern = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static final RegExp _phonePattern = RegExp(r'^(?:\+?[0-9]{10,15})$');
  static final RegExp _phoneSeparators = RegExp(r'[\s\-()]');
  static final RegExp _weakPasswordPattern = RegExp(
    'password|123456|qwerty',
    caseSensitive: false,
  );

  static bool isValidEmail(String value) => _emailPattern.hasMatch(value);

  static bool isValidPhoneNumber(String value) {
    final normalized = value.trim().replaceAll(_phoneSeparators, '');
    return _phonePattern.hasMatch(normalized);
  }

  static bool isStrongPassword(String password) {
    final value = password.trim();
    if (value.length < 8) return false;
    if (!RegExp('[A-Z]').hasMatch(value)) return false;
    if (!RegExp('[a-z]').hasMatch(value)) return false;
    if (!RegExp('[0-9]').hasMatch(value)) return false;
    if (value.contains(' ')) return false;
    if (_weakPasswordPattern.hasMatch(value)) return false;
    return true;
  }

  static bool passwordsMatch(String a, String b) {
    if (a.trim().isEmpty || b.trim().isEmpty) return false;
    return a == b;
  }

  static bool isLongEnough(String value, int minLength) =>
      value.length >= minLength;
}
