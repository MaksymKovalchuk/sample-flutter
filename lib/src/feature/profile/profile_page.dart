import 'package:flutter/material.dart';
import 'package:sample/src/core/di/injection.dart';
import 'package:sample/src/core/extensions/context_extension.dart';
import 'package:sample/src/core/session/logout_manager.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/core/theme/typography.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.cBgMain,
    appBar: AppBar(
      backgroundColor: context.colors.cBgMain,
      elevation: 0,
      title: Text(
        context.loc.profileTitle,
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
              Icons.person_outline,
              size: 64,
              color: context.colors.cIconMutedLghtr,
            ),
            const SizedBox(height: 16),
            Text(
              context.loc.profilePlaceholder,
              textAlign: TextAlign.center,
              style: StyleManager.styleText(
                fLSmall14,
                color: context.colors.cTextSec,
              ),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () =>
                  getIt<LogoutManager>().logout(source: 'ProfilePage'),
              icon: Icon(Icons.logout, color: context.colors.cStatusError),
              label: Text(
                context.loc.profileLogout,
                style: StyleManager.styleText(
                  fMedium16,
                  color: context.colors.cStatusError,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
