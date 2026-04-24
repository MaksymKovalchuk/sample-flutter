import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/caches/preferences.dart';
import 'package:sample/src/core/di/injection.config.dart';
import 'package:sample/src/core/network/checker/internet_connection_monitor.dart';
import 'package:sample/src/core/network/rest_client.dart';
import 'package:sample/src/core/network/token/token_provider.dart';
import 'package:sample/src/core/session/account_manager.dart';
import 'package:sample/src/core/session/logout_manager.dart';
import 'package:timezone/data/latest.dart' as tz;

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<GetIt> configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @preResolve
  @singleton
  Future<Preferences> get preferences async {
    final prefs = Preferences();
    await prefs.init();
    return prefs;
  }

  @preResolve
  @singleton
  Future<PackageInfo> get packageInfo async {
    tz.initializeTimeZones();
    return PackageInfo.fromPlatform();
  }

  @lazySingleton
  Client get httpClient => Client();

  @singleton
  InternetConnectionMonitor get internetMonitor {
    final monitor = InternetConnectionMonitor();
    unawaited(monitor.start());
    return monitor;
  }

  @lazySingleton
  LogoutManager logoutManager(
    Preferences prefs,
    TokenProvider tokenProvider,
    RestClient restClient,
    AccountManager accountManager,
  ) => LogoutManager(
    prefs: prefs,
    tokenProvider: tokenProvider,
    restClient: restClient,
    accountManager: accountManager,
    onLoggedOut: () => getIt<AppBloc>().add(LoggedOut()),
  );
}
