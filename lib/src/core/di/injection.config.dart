// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:sample/src/core/bloc/app_bloc.dart' as _i829;
import 'package:sample/src/core/caches/preferences.dart' as _i471;
import 'package:sample/src/core/di/injection.dart' as _i160;
import 'package:sample/src/core/localization/locale_provider.dart' as _i534;
import 'package:sample/src/core/network/checker/internet_connection_monitor.dart'
    as _i880;
import 'package:sample/src/core/network/rest/repositories/auth_repository.dart'
    as _i327;
import 'package:sample/src/core/network/rest/repositories/login_repository.dart'
    as _i752;
import 'package:sample/src/core/network/rest/repositories/posts_repository.dart'
    as _i980;
import 'package:sample/src/core/network/rest_client.dart' as _i532;
import 'package:sample/src/core/network/token/token_provider.dart' as _i813;
import 'package:sample/src/core/session/account_manager.dart' as _i415;
import 'package:sample/src/core/session/app_initializer.dart' as _i899;
import 'package:sample/src/core/session/logout_manager.dart' as _i708;
import 'package:sample/src/core/session/session_manager.dart' as _i596;
import 'package:sample/src/core/theme/app_theme.dart' as _i457;
import 'package:sample/src/feature/auth/bloc/auth_bloc.dart' as _i44;
import 'package:sample/src/feature/home/bloc/home_bloc.dart' as _i355;
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart' as _i924;
import 'package:sample/src/services/notifications/notification_manager.dart'
    as _i110;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i471.Preferences>(
      () => registerModule.preferences,
      preResolve: true,
    );
    await gh.singletonAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo,
      preResolve: true,
    );
    gh.singleton<_i880.InternetConnectionMonitor>(
      () => registerModule.internetMonitor,
    );
    gh.lazySingleton<_i519.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i534.LocaleProvider>(() => _i534.LocaleProvider());
    gh.lazySingleton<_i532.RestClient>(() => const _i532.RestClient());
    gh.lazySingleton<_i415.AccountManager>(() => _i415.AccountManager());
    gh.lazySingleton<_i457.AppTheme>(() => _i457.AppTheme());
    gh.lazySingleton<_i110.NotificationManager>(
      () => _i110.NotificationManager(),
    );
    gh.lazySingleton<_i327.AuthRepository>(
      () => _i327.AuthRepository(gh<_i532.RestClient>()),
    );
    gh.lazySingleton<_i980.PostsRepository>(
      () => _i980.PostsRepository(gh<_i532.RestClient>()),
    );
    gh.factory<_i355.HomeBloc>(
      () => _i355.HomeBloc(gh<_i980.PostsRepository>()),
    );
    gh.lazySingleton<_i813.TokenProvider>(
      () => _i813.TokenProvider(gh<_i519.Client>()),
    );
    gh.lazySingleton<_i708.LogoutManager>(
      () => registerModule.logoutManager(
        gh<_i471.Preferences>(),
        gh<_i813.TokenProvider>(),
        gh<_i532.RestClient>(),
        gh<_i415.AccountManager>(),
      ),
    );
    gh.lazySingleton<_i752.LoginRepository>(
      () => _i752.LoginRepository(
        gh<_i532.RestClient>(),
        gh<_i813.TokenProvider>(),
      ),
    );
    gh.lazySingleton<_i899.AppInitializer>(
      () => _i899.AppInitializer(
        gh<_i327.AuthRepository>(),
        gh<_i813.TokenProvider>(),
      ),
    );
    gh.factory<_i924.TabBarBloc>(
      () => _i924.TabBarBloc(gh<_i899.AppInitializer>()),
    );
    gh.lazySingleton<_i596.SessionManager>(
      () => _i596.SessionManager(
        initializer: gh<_i899.AppInitializer>(),
        tokenProvider: gh<_i813.TokenProvider>(),
      ),
    );
    gh.lazySingleton<_i829.AppBloc>(
      () => _i829.AppBloc(
        gh<_i899.AppInitializer>(),
        gh<_i813.TokenProvider>(),
        gh<_i596.SessionManager>(),
      ),
    );
    gh.factory<_i44.AuthBloc>(
      () => _i44.AuthBloc(gh<_i752.LoginRepository>(), gh<_i829.AppBloc>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i160.RegisterModule {}
