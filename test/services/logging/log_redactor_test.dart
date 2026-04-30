import 'package:flutter_test/flutter_test.dart';
import 'package:sample/src/services/logging/log_redactor.dart';

void main() {
  group('redactSensitive', () {
    test('masks top-level sensitive keys (case-insensitive)', () {
      final input = <String, dynamic>{
        'email': 'a@b.c',
        'password': 'hunter2',
        'Token': 'abc',
        'API_KEY': 'xyz',
      };
      final result = redactSensitive(input) as Map<dynamic, dynamic>;

      expect(result['email'], 'a@b.c');
      expect(result['password'], '***');
      expect(result['Token'], '***');
      expect(result['API_KEY'], '***');
    });

    test('recurses into nested maps', () {
      final input = <String, dynamic>{
        'user': {'name': 'Bob', 'password': 'p'},
        'meta': {'secret': 's', 'public': 'ok'},
      };
      final result = redactSensitive(input) as Map<dynamic, dynamic>;
      final user = result['user'] as Map<dynamic, dynamic>;
      final meta = result['meta'] as Map<dynamic, dynamic>;

      expect(user['name'], 'Bob');
      expect(user['password'], '***');
      expect(meta['secret'], '***');
      expect(meta['public'], 'ok');
    });

    test('recurses into lists', () {
      final input = <String, dynamic>{
        'creds': [
          {'password': 'p1'},
          {'password': 'p2'},
        ],
      };
      final result = redactSensitive(input) as Map<dynamic, dynamic>;
      final creds = result['creds'] as List<dynamic>;

      expect(creds.length, 2);
      expect((creds[0] as Map<dynamic, dynamic>)['password'], '***');
      expect((creds[1] as Map<dynamic, dynamic>)['password'], '***');
    });

    test('returns scalars and unknown shapes unchanged', () {
      expect(redactSensitive(42), 42);
      expect(redactSensitive('hello'), 'hello');
      expect(redactSensitive(null), null);
    });

    test('does not mask non-sensitive keys', () {
      final input = <String, dynamic>{
        'username': 'bob',
        'note': 'token of love',
      };
      final result = redactSensitive(input) as Map<dynamic, dynamic>;

      expect(result['username'], 'bob');
      expect(
        result['note'],
        'token of love',
      ); // value contains "token" — not masked
    });
  });
}
