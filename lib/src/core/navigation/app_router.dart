import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/di/locator.dart';
import 'package:sample/src/core/navigation/auth_guard.dart';
import 'package:sample/src/core/navigation/navigation_service.dart';
import 'package:sample/src/core/navigation/route_names.dart';
import 'package:sample/src/core/navigation/router_refresh_stream.dart';
import 'package:sample/src/core/navigation/transitions.dart';
import 'package:sample/src/feature/auth/auth_page.dart';
import 'package:sample/src/feature/tab_bar/tab_bar_page.dart';

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RouteNames.init,
  refreshListenable: GoRouterRefreshStream(locator<AppBloc>().stream),
  redirect: (context, state) {
    final appState = context.read<AppBloc>().state;
    return AuthGuard.redirectLogic(appState, state.uri.path);
  },
  routes: [
    GoRoute(
      path: RouteNames.init,
      pageBuilder: (context, state) =>
          fadeTransitionPage(name: RouteNames.init, child: const SizedBox()),
    ),
    GoRoute(
      path: RouteNames.auth,
      pageBuilder: (context, state) =>
          fadeTransitionPage(name: RouteNames.auth, child: const AuthPage()),
    ),
    GoRoute(
      path: RouteNames.tabBar,
      pageBuilder: (context, state) {
        final uuid = state.uri.queryParameters['uuid'];
        return fadeTransitionPage(
          name: RouteNames.tabBar,
          child: TabBarPage(uuid: uuid),
        );
      },
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(body: Center(child: Text('404 ${state.uri.path}'))),
  ),
);
