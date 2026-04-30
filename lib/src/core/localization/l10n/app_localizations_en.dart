// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get assetTotal => 'Total';

  @override
  String get authTitle => 'Welcome back';

  @override
  String get authSubtitle => 'Sign in to continue';

  @override
  String get authEmailHint => 'Email';

  @override
  String get authPasswordHint => 'Password';

  @override
  String get authSubmit => 'Sign in';

  @override
  String get authDemoHint => 'Demo: enter any valid email and 6+ char password';

  @override
  String get homeTitle => 'Home';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profilePlaceholder =>
      'Your profile lives here.\nWire it up to your /me endpoint.';

  @override
  String get profileLogout => 'Sign out';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPlaceholder =>
      'Theme and locale switchers go here.\nSee the comment in settings_page.dart.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabProfile => 'Profile';

  @override
  String get tabSettings => 'Settings';

  @override
  String get commonRetry => 'Retry';

  @override
  String get connectivityOffline => 'No internet connection';
}
