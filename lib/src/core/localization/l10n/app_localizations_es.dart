// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get assetTotal => 'Total';

  @override
  String get authTitle => 'Bienvenido de nuevo';

  @override
  String get authSubtitle => 'Inicia sesión para continuar';

  @override
  String get authEmailHint => 'Correo electrónico';

  @override
  String get authPasswordHint => 'Contraseña';

  @override
  String get authSubmit => 'Iniciar sesión';

  @override
  String get authDemoHint =>
      'Demo: cualquier email válido y contraseña de 6+ caracteres';

  @override
  String get homeTitle => 'Inicio';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profilePlaceholder =>
      'Tu perfil va aquí.\nConéctalo con tu endpoint /me.';

  @override
  String get profileLogout => 'Cerrar sesión';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsPlaceholder =>
      'Selectores de tema e idioma van aquí.\nVer comentario en settings_page.dart.';

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get connectivityOffline => 'Sin conexión a internet';
}
