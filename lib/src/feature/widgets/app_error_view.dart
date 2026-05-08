import 'package:flutter/material.dart';
import 'package:sample/src/core/extensions/context_extension.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/core/theme/typography.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    required this.message,
    super.key,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: context.colors.cStatusError),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: StyleManager.styleText(
              fLSmall14,
              color: context.colors.cTextSec,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: Text(context.loc.commonRetry),
            ),
          ],
        ],
      ),
    ),
  );
}
