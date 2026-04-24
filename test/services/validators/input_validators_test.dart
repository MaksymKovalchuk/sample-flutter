import 'package:flutter_test/flutter_test.dart';
import 'package:sample/src/services/validators/input_validators.dart';

void main() {
  group('InputValidators.isValidEmail', () {
    test('accepts well-formed emails', () {
      expect(InputValidators.isValidEmail('user@example.com'), isTrue);
      expect(InputValidators.isValidEmail('a.b+tag@sub.domain.co'), isTrue);
    });

    test('rejects malformed emails', () {
      expect(InputValidators.isValidEmail(''), isFalse);
      expect(InputValidators.isValidEmail('no-at-sign'), isFalse);
      expect(InputValidators.isValidEmail('missing@tld'), isFalse);
      expect(InputValidators.isValidEmail('@no-local.com'), isFalse);
    });
  });

  group('InputValidators.isValidPhoneNumber', () {
    test('accepts digits with/without +, and common separators', () {
      expect(InputValidators.isValidPhoneNumber('+380501234567'), isTrue);
      expect(InputValidators.isValidPhoneNumber('0501234567'), isTrue);
      expect(InputValidators.isValidPhoneNumber('+1 (555) 123-4567'), isTrue);
    });

    test('rejects non-phone input', () {
      expect(InputValidators.isValidPhoneNumber(''), isFalse);
      expect(InputValidators.isValidPhoneNumber('abc'), isFalse);
      expect(InputValidators.isValidPhoneNumber('123'), isFalse); // too short
    });
  });

  group('InputValidators.isStrongPassword', () {
    test('accepts passwords with upper/lower/digit, no spaces, 8+ chars', () {
      expect(InputValidators.isStrongPassword('Strong12'), isTrue);
      expect(InputValidators.isStrongPassword('LongEnough9'), isTrue);
    });

    test('rejects weak passwords', () {
      expect(InputValidators.isStrongPassword('short1A'), isFalse); // <8
      expect(
        InputValidators.isStrongPassword('alllowercase1'),
        isFalse,
      ); // no upper
      expect(
        InputValidators.isStrongPassword('ALLUPPER123'),
        isFalse,
      ); // no lower
      expect(
        InputValidators.isStrongPassword('NoDigits!'),
        isFalse,
      ); // no digit
      expect(InputValidators.isStrongPassword('has space1A'), isFalse);
      expect(InputValidators.isStrongPassword('Password1'), isFalse); // common
      expect(InputValidators.isStrongPassword('Qwerty123'), isFalse); // common
    });
  });

  group('InputValidators.passwordsMatch', () {
    test('returns true only when both non-empty and equal', () {
      expect(InputValidators.passwordsMatch('abc', 'abc'), isTrue);
      expect(InputValidators.passwordsMatch('abc', 'abd'), isFalse);
      expect(InputValidators.passwordsMatch('', 'abc'), isFalse);
      expect(InputValidators.passwordsMatch('abc', ''), isFalse);
    });
  });

  group('InputValidators.isLongEnough', () {
    test('compares length to minLength', () {
      expect(InputValidators.isLongEnough('abc', 3), isTrue);
      expect(InputValidators.isLongEnough('abcd', 3), isTrue);
      expect(InputValidators.isLongEnough('ab', 3), isFalse);
      expect(InputValidators.isLongEnough('', 1), isFalse);
    });
  });
}
