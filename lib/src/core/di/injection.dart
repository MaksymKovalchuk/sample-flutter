import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/caches/preferences.dart';
import 'package:sample/src/core/localization/locale_provider.dart';
import 'package:sample/src/core/network/checker/internet_connection_monitor.dart';
import 'package:sample/src/core/network/rest/repositories/auth_repository.dart';
import 'package:sample/src/core/network/rest/repositories/login_repository.dart';
import 'package:sample/src/core/network/rest/repositories/posts_repository.dart';
import 'package:sample/src/core/network/rest_client.dart';
import 'package:sample/src/core/network/token/token_provider.dart';
import 'package:sample/src/core/session/account_manager.dart';
import 'package:sample/src/core/session/app_initializer.dart';
import 'package:sample/src/core/session/logout_manager.dart';
import 'package:sample/src/core/session/session_manager.dart';
import 'package:sample/src/core/theme/app_theme.dart';
import 'package:sample/src/feature/auth/bloc/auth_bloc.dart';
import 'package:sample/src/feature/home/bloc/home_bloc.dart';
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart';
import 'package:sample/src/services/notifications/notification_manager.dart';
import 'package:timezone/data/latest.dart' as tz;

final locator = GetIt.instance;

Future<void> setupLocator() async {
  await _registerSystem();
  _registerNetwork();
  _registerSession();
  _registerRepositories();
  _registerBlocs();
}

// 🧩 SYSTEM
Future<void> _registerSystem() async {
  final prefs = Preferences();
  await prefs.init();
  locator.registerSingleton<Preferences>(prefs);

  tz.initializeTimeZones();
  final pkg = await PackageInfo.fromPlatform();
  locator.registerSingleton<PackageInfo>(pkg);

  locator.registerLazySingleton(AppTheme.new);
  locator.registerLazySingleton(LocaleProvider.new);
  locator.registerLazySingleton(NotificationManager.new);
}

// 🌐 NETWORK
void _registerNetwork() {
  final l = locator;

  l.registerLazySingleton<Client>(Client.new);
  l.registerLazySingleton(() => const RestClient());
  l.registerLazySingleton(() => TokenProvider(l()));

  final monitor = InternetConnectionMonitor();
  unawaited(monitor.start());
  l.registerSingleton<InternetConnectionMonitor>(monitor);
}

// 🔐 SESSION  (order: Account → Initializer → Logout → Session)
void _registerSession() {
  final l = locator;

  l.registerLazySingleton(AccountManager.new);
  l.registerLazySingleton(() => AppInitializer(l(), l()));

  l.registerLazySingleton(
    () => LogoutManager(
      prefs: l(),
      tokenProvider: l(),
      restClient: l(),
      accountManager: l(),
      onLoggedOut: () => l<AppBloc>().add(LoggedOut()),
    ),
  );

  l.registerLazySingleton(
    () => SessionManager(initializer: l(), tokenProvider: l()),
  );
}

// 🗄 REPOSITORIES
void _registerRepositories() {
  final l = locator;
  final c = l<RestClient>();

  l.registerLazySingleton(() => AuthRepository(c));
  l.registerLazySingleton(() => LoginRepository(c, l()));
  l.registerLazySingleton(() => PostsRepository(c));
}

// 🧠 BLOCS  (lazy singletons = global; factory = per-page)
void _registerBlocs() {
  final l = locator;

  l.registerLazySingleton(() => AppBloc(l(), l(), l()));
  l.registerLazySingleton(() => TabBarBloc(l()));

  l.registerFactory(() => AuthBloc(l(), l()));
  l.registerFactory(() => HomeBloc(l()));
}
