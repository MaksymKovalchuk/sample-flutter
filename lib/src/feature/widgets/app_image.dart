import 'package:sample/src/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class AppImage extends StatefulWidget {
  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.symbol,
  });
  final String path;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final Widget? placeholder;
  final String? symbol;

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  static final Map<String, bool> _existenceCache = {};
  late Future<bool> _assetExists;

  bool get _isSvg => widget.path.toLowerCase().endsWith('.svg');

  Future<bool> _checkAssetExists(String path) async {
    if (_existenceCache.containsKey(path)) {
      return _existenceCache[path]!;
    }
    try {
      await rootBundle.load(path);
      _existenceCache[path] = true;
      return true;
    } catch (_) {
      _existenceCache[path] = false;
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _assetExists = _checkAssetExists(widget.path);
  }

  @override
  void didUpdateWidget(covariant AppImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _assetExists = _checkAssetExists(widget.path);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
        future: _assetExists,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return widget.placeholder ??
                SizedBox(width: widget.width, height: widget.height);
          }

          if (!snapshot.data!) {
            return _buildErrorWidget();
          }

          return _isSvg
              ? SvgPicture.asset(
                  widget.path,
                  key: ValueKey(widget.path),
                  width: widget.width,
                  height: widget.height,
                  colorFilter: widget.color == null
                      ? null
                      : ColorFilter.mode(widget.color!, BlendMode.srcIn),
                  fit: widget.fit,
                  placeholderBuilder: (_) =>
                      widget.placeholder ??
                      SizedBox(width: widget.width, height: widget.height),
                  errorBuilder: (_, __, ___) => _buildErrorWidget(),
                )
              : Image.asset(
                  widget.path,
                  key: ValueKey(widget.path),
                  width: widget.width,
                  height: widget.height,
                  color: widget.color,
                  fit: widget.fit,
                  errorBuilder: (_, __, ___) => _buildErrorWidget(),
                );
        },
      );

  Widget _buildErrorWidget() {
    final String fallbackText = (widget.symbol?.trim().isNotEmpty ?? false)
        ? widget.symbol!
            .trim()
            .substring(0, widget.symbol!.length >= 2 ? 2 : 1)
            .toUpperCase()
        : '';

    return Container(
      width: widget.width,
      height: widget.height,
      color: context.colors.cIconActive.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: Text(fallbackText,
          style: TextStyle(
            fontSize: (widget.width ?? 14) * 0.4,
            fontWeight: FontWeight.w600,
            color: context.colors.cTextSofter,
          )),
    );
  }
}
