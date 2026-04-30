import 'package:flutter/material.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/core/theme/typography.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final bg = isEnabled
        ? context.colors.cBtnPrimary
        : context.colors.cBtnDisabled;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isEnabled ? onPressed : null,
        child: Container(
          height: height,
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: context.colors.cButtonText,
                  ),
                )
              : Text(
                  label,
                  style: StyleManager.styleText(
                    fMedium16,
                    weight: semiBold,
                    color: context.colors.cButtonText,
                  ),
                ),
        ),
      ),
    );
  }
}
