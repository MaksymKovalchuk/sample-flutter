import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:sample/src/core/bloc/app_bloc.dart';
import 'package:sample/src/core/di/injection.dart';
import 'package:sample/src/core/localization/l10n/app_localizations.dart';
import 'package:sample/src/core/localization/locale_provider.dart';
import 'package:sample/src/core/localization/supported_locales.dart';
import 'package:sample/src/core/navigation/app_router.dart';
import 'package:sample/src/core/navigation/navigation_service.dart';
import 'package:sample/src/core/navigation/route_names.dart';
import 'package:sample/src/core/theme/app_theme.dart';
import 'package:sample/src/core/theme/theme_dark.dart';
import 'package:sample/src/core/theme/theme_light.dart';
import 'package:sample/src/core/widgets/app_snack_bar.dart';
import 'package:sample/src/core/widgets/offline_banner.dart';
import 'package:sample/src/feature/app/model/dependencies.dart';
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart';
import 'package:sample/src/services/device/device_info_service.dart';

/// Root application widget. Attach by calling [App.attach].
class App extends StatefulWidget {
  const App({required this.result, super.key});

  final InitializationResult result;

  /// Runs this widget as the app root. Call `callback` (e.g. splash removal)
  /// right before attaching.
  void attach([VoidCallback? callback]) {
    callback?.call();
    runApp(this);
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static final SystemUiOverlayStyle _systemTheme = SystemUiOverlayStyle.light
      .copyWith(
        systemNavigationBarColor: const Color(0xFF101114),
        systemNavigationBarDividerColor: const Color(0xFF101114),
        systemNavigationBarIconBrightness: Brightness.light,
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeviceInfoService.setPreferredOrientation();
    });
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: _systemTheme,
    child: MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (_) => getIt<AppBloc>()..add(AppStarted()),
        ),
        BlocProvider<TabBarBloc>(create: (_) => getIt<TabBarBloc>()),
      ],
      child: BlocListener<AppBloc, AppState>(
        listenWhen: (previous, current) =>
            current is AuthUnauthenticated || current is LogoutFailure,
        listener: (context, state) async {
          if (state is AuthUnauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              rootNavigatorKey.currentContext?.go(RouteNames.auth);
            });
          } else if (state is LogoutFailure) {
            SnackBarManager().show(context, message: state.message);
          }
        },
        child: _buildMaterialApp(),
      ),
    ),
  );

  Widget _buildMaterialApp() {
    final themeNotifier = getIt<AppTheme>().themeNotifier;
    final localeProvider = getIt<LocaleProvider>();

    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, localeProvider]),
      builder: (context, _) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          locale: localeProvider.locale,
          supportedLocales: SupportedLocales.all,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: LightTheme.create(context),
          darkTheme: DarkTheme.create(context),
          themeMode: themeNotifier.value,
          builder: (context, child) =>
              OfflineBanner(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
