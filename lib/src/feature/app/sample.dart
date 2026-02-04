import 'package:sample/src/core/localization/l10n/app_localizations.dart';
import 'package:sample/src/core/localization/locale_provider.dart';
import 'package:sample/src/core/localization/supported_locales.dart';
import 'package:sample/src/core/navigation/core/route_names.dart';
import 'package:sample/src/core/di/locator.dart';
import 'package:sample/src/core/navigation/core/navigation_service.dart';
import 'package:sample/src/core/theme/app_theme.dart';
import 'package:sample/src/core/theme/theme_dark.dart';
import 'package:sample/src/core/theme/theme_light.dart';
import 'package:sample/src/feature/tab_bar/bloc/tab_bar_bloc.dart';
import 'package:sample/src/feature/widgets/app_snack_bar.dart';
import 'package:sample/src/services/device/device_info_service.dart';
import 'package:sample/src/services/firebase/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import '../../core/bloc/app_bloc.dart';
import '../../core/caches/preferences.dart';
import '../../core/navigation/app_router.dart';

class Sample extends StatefulWidget {
  const Sample({
    super.key,
    required this.notifications,
    required this.preferences,
  });

  final NotificationManager notifications;
  final Preferences preferences;

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  static final SystemUiOverlayStyle _systemTheme =
      SystemUiOverlayStyle.light.copyWith(
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
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemTheme,
      child: MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>(
                create: (_) => locator<AppBloc>()..add(AppStarted())),
            BlocProvider<TabBarBloc>(create: (_) => locator<TabBarBloc>()),
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
            child: _buildApp(),
          )));

  Widget _buildApp() {
    final themeNotifier = locator<AppTheme>().themeNotifier;
    final localeProvider = locator<LocaleProvider>();

    return AnimatedBuilder(
        animation: Listenable.merge([themeNotifier, localeProvider]),
        builder: (context, _) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: MaterialApp.router(
                routerConfig: router,
                debugShowCheckedModeBanner: false,
                locale: localeProvider.locale,
                supportedLocales: SupportedLocales.all,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                theme: LightTheme.create(context),
                darkTheme: DarkTheme.create(context),
                themeMode: themeNotifier.value,
              ),
            ));
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
