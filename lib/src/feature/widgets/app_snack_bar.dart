import 'package:sample/src/core/constants/images.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/services/logging/logger.dart';
import 'package:flutter/material.dart';
import 'package:sample/src/core/theme/colors.dart';

enum SnackBarType { error, success, warning, order }

class SnackBarManager {
  factory SnackBarManager() => _instance;
  SnackBarManager._internal();
  static final SnackBarManager _instance = SnackBarManager._internal();

  final List<_TimedSnackBar> _activeSnackBars = [];
  final ValueNotifier<List<_TimedSnackBar>> _snackBarsNotifier =
      ValueNotifier([]);
  OverlayEntry? _overlayEntry;

  void show(
    BuildContext context, {
    required String? message,
    String? title,
    SnackBarType type = SnackBarType.error,
    int durationMs = 2000,
    int maxVisible = 1,
  }) {
    final key = UniqueKey();

    final iconColor = {
      SnackBarType.error: context.colors.cBtnSell,
      SnackBarType.success: context.colors.cBtnBuy,
      SnackBarType.warning: context.colors.cWarningText,
      SnackBarType.order: context.colors.cBtnBuy,
    }[type];

    final textColor = {
      SnackBarType.error: context.colors.cTextSofter,
      SnackBarType.success: context.colors.cTextSofter,
      SnackBarType.warning: context.colors.cTextSofter,
      SnackBarType.order: context.colors.cTextSofter,
    }[type];

    final backgroundColor = {
      SnackBarType.error: context.colors.cFieldTap,
      SnackBarType.success: context.colors.cFieldTap,
      SnackBarType.warning: context.colors.cFieldTap,
      SnackBarType.order: context.colors.cFieldTap,
    }[type];

    final typeIcon = {
          SnackBarType.error: ImagePaths.cancel,
          SnackBarType.success: ImagePaths.verify,
          SnackBarType.warning: ImagePaths.fullInfo,
          SnackBarType.order: ImagePaths.verify,
        }[type] ??
        "";

    final snackbar = Material(
      key: key,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Dismissible(
            key: key,
            direction: DismissDirection.up,
            onDismissed: (_) => _removeByKey(key),
            child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Image.asset(typeIcon,
                            height: 16, width: 16, color: iconColor)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          Text(
                            title,
                            style: StyleManager.styleText(13,
                                weight: 520, color: iconColor, height: 1.6),
                          ),
                        Text(message ?? "",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: StyleManager.styleText(12,
                                color: textColor, height: 1.6)),
                      ],
                    )),
                    const SizedBox(width: 6),
                    Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: InkWell(
                            onTap: () => _removeByKey(key),
                            child: Image.asset(
                              ImagePaths.cancel,
                              width: 16,
                              height: 16,
                              color: context.colors.cTextSofter,
                            ))),
                  ],
                ))),
      ),
    );

    _activeSnackBars.insert(0, _TimedSnackBar(key: key, widget: snackbar));

    if (_activeSnackBars.length > maxVisible) {
      _activeSnackBars.removeRange(maxVisible, _activeSnackBars.length);
    }

    _snackBarsNotifier.value = List.from(_activeSnackBars);
    _showOverlay(context);

    Future.delayed(Duration(milliseconds: durationMs), () {
      _removeByKey(key);
    });
  }

  void _removeByKey(Key key) {
    _activeSnackBars.removeWhere((e) => e.key == key);
    _snackBarsNotifier.value = List.from(_activeSnackBars);

    if (_activeSnackBars.isEmpty && _overlayEntry != null) {
      try {
        if (_overlayEntry!.mounted) _overlayEntry!.remove();
      } catch (e, stack) {
        logger.error("Overlay remove failed", error: e, stackTrace: stack);
      } finally {
        _overlayEntry = null;
      }
    }
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (_) => SafeArea(
          child: Align(
        alignment: Alignment.topCenter,
        child: _SnackBarOverlay(snackBarsNotifier: _snackBarsNotifier),
      )),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Navigator.of(context).overlay;
      if (overlay != null && _overlayEntry != null) {
        overlay.insert(_overlayEntry!);
      }
    });
  }
}

class _TimedSnackBar {
  _TimedSnackBar({required this.key, required this.widget});
  final Key key;
  final Widget widget;
}

class _SnackBarOverlay extends StatelessWidget {
  const _SnackBarOverlay({required this.snackBarsNotifier});
  final ValueNotifier<List<_TimedSnackBar>> snackBarsNotifier;

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<List<_TimedSnackBar>>(
          valueListenable: snackBarsNotifier,
          builder: (context, snackBars, _) => Column(
              mainAxisSize: MainAxisSize.min,
              children: snackBars
                  .map((e) => IgnorePointer(ignoring: false, child: e.widget))
                  .toList()));
}
