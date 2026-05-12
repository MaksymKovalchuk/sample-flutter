import 'package:flutter/material.dart';
import 'package:sample/src/core/di/locator.dart';
import 'package:sample/src/core/extensions/context_extension.dart';
import 'package:sample/src/core/network/checker/internet_connection_monitor.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/core/theme/typography.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final monitor = locator<InternetConnectionMonitor>();
    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: ValueListenableBuilder<bool>(
            valueListenable: monitor,
            builder: (context, isOnline, _) => AnimatedSlide(
              offset: isOnline ? const Offset(0, -1) : Offset.zero,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: SafeArea(
                bottom: false,
                child: Material(
                  color: context.colors.cStatusError,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          size: 16,
                          color: context.colors.cButtonText,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.loc.connectivityOffline,
                          style: StyleManager.styleText(
                            fXSmall12,
                            weight: medium,
                            color: context.colors.cButtonText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
