import 'package:flutter/material.dart';
import 'package:sample/src/core/extensions/context_extension.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/core/theme/typography.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Placeholder. Wire AppTheme + LocaleProvider for real switchers:
  //   getIt<AppTheme>().setTypeTheme(index);   // 0 system / 1 light / 2 dark
  //   getIt<LocaleProvider>().setLocale(...)   // SupportedLocales.english/spanish
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.cBgMain,
    appBar: AppBar(
      backgroundColor: context.colors.cBgMain,
      elevation: 0,
      title: Text(
        context.loc.settingsTitle,
        style: StyleManager.styleText(
          fLarge18,
          weight: semiBold,
          color: context.colors.cTextPrimary,
        ),
      ),
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.settings_outlined,
              size: 64,
              color: context.colors.cIconMutedLghtr,
            ),
            const SizedBox(height: 16),
            Text(
              context.loc.settingsPlaceholder,
              textAlign: TextAlign.center,
              style: StyleManager.styleText(
                fLSmall14,
                color: context.colors.cTextSec,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
