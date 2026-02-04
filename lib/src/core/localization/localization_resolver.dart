import 'package:sample/src/core/localization/l10n/app_localizations.dart';

class LocalizationResolver {
  final AppLocalizations l10n;

  LocalizationResolver(this.l10n);

  String resolve(String key) {
    final map = <String, String>{};

    return map[key] ?? key;
  }
}
