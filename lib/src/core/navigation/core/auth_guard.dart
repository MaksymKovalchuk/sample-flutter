import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/navigation/core/route_names.dart';

class AuthGuard {
  const AuthGuard._();

  static bool isUninitialized(AppState state) => state is AuthUninitialized;

  static bool isOnLoginScreen(String path) => path.startsWith(RouteNames.auth);

  static String? redirectLogic(
    AppBloc bloc,
    AppState state,
    String currentPath,
  ) {
    if (isUninitialized(state)) return null;

    final onLogin = isOnLoginScreen(currentPath);

    if (!onLogin) return RouteNames.auth;
    if (onLogin) return RouteNames.tabBar;

    return null;
  }
}
