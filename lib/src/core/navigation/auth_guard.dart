import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/navigation/route_names.dart';

class AuthGuard {
  const AuthGuard._();

  static bool isOnLoginScreen(String path) => path.startsWith(RouteNames.auth);

  static String? redirectLogic(AppState state, String currentPath) {
    if (state is AuthUninitialized || state is AuthInProgress) return null;

    // /init is a transient splash; always redirect away once auth is resolved.
    if (currentPath == RouteNames.init) {
      if (state is AuthAuthenticated) return RouteNames.tabBar;
      if (state is AuthUnauthenticated) return RouteNames.auth;
    }

    final onLogin = isOnLoginScreen(currentPath);

    if (state is AuthUnauthenticated) {
      return onLogin ? null : RouteNames.auth;
    }

    if (state is AuthAuthenticated) {
      return onLogin ? RouteNames.tabBar : null;
    }

    return null;
  }
}
