import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/di/locator.dart';
import 'package:sample/src/core/navigation/core/auth_guard.dart';
import 'package:sample/src/core/navigation/core/navigation_service.dart';
import 'package:sample/src/core/navigation/core/router_refresh_stream.dart';
import 'package:sample/src/core/navigation/core/transitions.dart';
import 'package:flutter/material.dart';
import 'package:sample/src/core/navigation/core/route_names.dart';
import 'package:sample/src/feature/tab_bar/tab_bar_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RouteNames.init,
  refreshListenable: GoRouterRefreshStream(locator<AppBloc>().stream),
  redirect: (BuildContext context, GoRouterState state) {
    final appBloc = context.read<AppBloc>();
    final appState = appBloc.state;
    final path = state.uri.path;

    return AuthGuard.redirectLogic(appBloc, appState, path);
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
          fadeTransitionPage(name: RouteNames.auth, child: const SizedBox()),
    ),
    GoRoute(
      path: RouteNames.tabBar,
      pageBuilder: (context, state) {
        final uuid = state.uri.queryParameters['uuid'];
        return fadeTransitionPage(
            name: RouteNames.tabBar, child: TabBarPage(uuid: uuid));
      },
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(body: Center(child: Text('404 ${state.uri.path}'))),
  ),
);
