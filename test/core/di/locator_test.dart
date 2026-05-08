import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/caches/preferences.dart';
import 'package:sample/src/core/di/injection.dart';
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

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    PackageInfo.setMockInitialValues(
      appName: 'test',
      packageName: 'test',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );

    FlutterSecureStorage.setMockInitialValues({});

    // path_provider stub for Hive boxes
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => '.',
        );

    await setupLocator();
  });

  tearDownAll(() async => locator.reset());

  group('setupLocator registers all critical services', () {
    test('system', () {
      expect(locator.isRegistered<Preferences>(), isTrue);
      expect(locator.isRegistered<PackageInfo>(), isTrue);
      expect(locator.isRegistered<AppTheme>(), isTrue);
      expect(locator.isRegistered<LocaleProvider>(), isTrue);
      expect(locator.isRegistered<NotificationManager>(), isTrue);
    });

    test('network', () {
      expect(locator.isRegistered<RestClient>(), isTrue);
      expect(locator.isRegistered<TokenProvider>(), isTrue);
      expect(locator.isRegistered<InternetConnectionMonitor>(), isTrue);
    });

    test('session', () {
      expect(locator.isRegistered<AccountManager>(), isTrue);
      expect(locator.isRegistered<AppInitializer>(), isTrue);
      expect(locator.isRegistered<LogoutManager>(), isTrue);
      expect(locator.isRegistered<SessionManager>(), isTrue);
    });

    test('repositories', () {
      expect(locator.isRegistered<AuthRepository>(), isTrue);
      expect(locator.isRegistered<LoginRepository>(), isTrue);
      expect(locator.isRegistered<PostsRepository>(), isTrue);
    });

    test('blocs', () {
      expect(locator.isRegistered<AppBloc>(), isTrue);
      expect(locator.isRegistered<TabBarBloc>(), isTrue);
      expect(locator.isRegistered<AuthBloc>(), isTrue);
      expect(locator.isRegistered<HomeBloc>(), isTrue);
    });

    test('factory blocs return new instance every call', () {
      final a = locator<AuthBloc>();
      final b = locator<AuthBloc>();
      expect(identical(a, b), isFalse);
    });

    test('lazy singletons return same instance every call', () {
      final a = locator<RestClient>();
      final b = locator<RestClient>();
      expect(identical(a, b), isTrue);
    });
  });
}
