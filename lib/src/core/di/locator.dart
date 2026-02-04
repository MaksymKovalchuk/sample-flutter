import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/caches/preferences.dart';
import 'package:sample/src/core/localization/locale_provider.dart';
import 'package:sample/src/core/network/token/token_provider.dart';
import 'package:sample/src/core/network/checker/internet_connection_monitor.dart';
import 'package:sample/src/core/network/core/rest_client.dart';
import 'package:sample/src/core/network/rest/repositories/auth_repository.dart';
import 'package:sample/src/core/session/account_manager.dart';
import 'package:sample/src/core/session/session_manager.dart';
import 'package:sample/src/core/theme/app_theme.dart';
import 'package:sample/src/core/app_initializer/app_initializer.dart';
import 'package:sample/src/core/session/logout_manager.dart';
import 'package:sample/src/services/firebase/notification_manager.dart';
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timezone/data/latest.dart';
import 'package:http/http.dart';

import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  await _registerSystem();
  await _registerPlatformAndTime();
  await _registerNotifications();
  await _registerAuthServices();
  await _registerRestServices();
  await _registerSessionManager();
  await _registerRepositories();
  await _registerVerifierStatus();

  await _registerBlocs();
  await _registerUtils();
}

// 🧩 SYSTEM
Future<void> _registerSystem() async {
  final preferences = Preferences();
  await preferences.init();
  locator.registerSingleton<Preferences>(preferences);

  locator.registerSingleton<AppTheme>(AppTheme());
  locator.registerSingleton<LocaleProvider>(LocaleProvider());

  final monitor = InternetConnectionMonitor(onReconnect: () {
    // Guard: SocketClient may not be registered yet at app startup
  });

  locator.registerSingleton<InternetConnectionMonitor>(monitor);
  monitor.start();
}

Future<void> _registerVerifierStatus() async {}

// ⏱ TIME & PLATFORM
Future<void> _registerPlatformAndTime() async {
  initializeTimeZones();
  final packageInfo = await PackageInfo.fromPlatform();
  locator.registerSingleton<PackageInfo>(packageInfo);
}

// 🔔 NOTIFICATIONS
Future<void> _registerNotifications() async {
  locator.registerSingleton<NotificationManager>(NotificationManager());
}

// 🌐 SERVICES REST
Future<void> _registerRestServices() async {
  locator.registerLazySingleton(() => const RestClient());
}

Future<void> _registerSessionManager() async {
  final l = locator;
  l.registerLazySingleton<SessionManager>(() => SessionManager(
        initializer: l<AppInitializer>(),
        tokenProvider: l<TokenProvider>(),
        logoutManager: l<LogoutManager>(),
      ));
}

Future<void> _registerAuthServices() async {
  final l = locator;
  l.registerLazySingleton(() => TokenProvider(Client()));
  l.registerLazySingleton<AppInitializer>(() => AppInitializer(l(), l()));
  l.registerLazySingleton<LogoutManager>(() => LogoutManager(
        prefs: l<Preferences>(),
        tokenProvider: l<TokenProvider>(),
        restClient: l<RestClient>(),
        accountManager: l<AccountManager>(),
        onLoggedOut: () => l<AppBloc>().add(LoggedOut()),
      ));
}

// 🗄 REPOSITORIES
Future<void> _registerRepositories() async {
  final l = locator;
  final client = l<RestClient>();

  l.registerLazySingleton(() => AuthRepository(client));
}

// 🌐 UTILS
Future<void> _registerUtils() async {
  final l = locator;

  l.registerLazySingleton(() => AccountManager());
}

// 🧠 BLOCS
Future<void> _registerBlocs() async {
  final l = locator;

  l.registerLazySingleton(() => AppBloc(l(), l(), l()));
  l.registerFactory(() => TabBarBloc());
}
