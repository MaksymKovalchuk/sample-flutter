import 'package:flutter_test/flutter_test.dart';
import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/navigation/auth_guard.dart';
import 'package:sample/src/core/navigation/route_names.dart';

void main() {
  group('AuthGuard.redirectLogic', () {
    test('returns null while state is uninitialized', () {
      final result = AuthGuard.redirectLogic(
        const AuthUninitialized(),
        RouteNames.tabBar,
      );
      expect(result, isNull);
    });

    test('returns null while auth is in progress', () {
      final result = AuthGuard.redirectLogic(
        const AuthInProgress(),
        RouteNames.tabBar,
      );
      expect(result, isNull);
    });

    test('redirects unauthenticated user to auth screen', () {
      final result = AuthGuard.redirectLogic(
        const AuthUnauthenticated(),
        RouteNames.tabBar,
      );
      expect(result, RouteNames.auth);
    });

    test('keeps unauthenticated user on auth screen', () {
      final result = AuthGuard.redirectLogic(
        const AuthUnauthenticated(),
        RouteNames.auth,
      );
      expect(result, isNull);
    });

    test('redirects authenticated user away from auth screen', () {
      final result = AuthGuard.redirectLogic(
        const AuthAuthenticated(),
        RouteNames.auth,
      );
      expect(result, RouteNames.tabBar);
    });

    test('keeps authenticated user on protected route', () {
      final result = AuthGuard.redirectLogic(
        const AuthAuthenticated(),
        RouteNames.tabBar,
      );
      expect(result, isNull);
    });
  });
}
