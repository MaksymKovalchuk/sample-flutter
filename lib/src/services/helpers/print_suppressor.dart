import 'dart:async';
import 'package:flutter/foundation.dart';

// suppresses noisy iOS WebView header logs
class PrintSuppressor {
  const PrintSuppressor._();

  static ZoneSpecification zoneSpec({List<String>? customFilters}) {
    if (kReleaseMode) return const ZoneSpecification(); // Do nothing in release

    final filters = customFilters ?? _defaultFilters;

    return ZoneSpecification(
      print: (self, parent, zone, line) {
        if (_shouldSuppress(line, filters)) return;
        parent.print(zone, line);
      },
    );
  }

  static bool _shouldSuppress(String? message, List<String> filters) {
    if (message == null) return false;
    return filters.any((f) => message.contains(f));
  }

  static const List<String> _defaultFilters = [
    'content-type:',
    'x-frame-options',
    'x-xss-protection',
    'x-content-type-options',
    'transfer-encoding: chunked',
    'flutter: Webview Console LOG:',
    'unhandled element <filter/>; Picture key: Svg loader',
  ];
}
