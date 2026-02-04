import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

const _trDuration = Duration(milliseconds: 250);

CustomTransitionPage<T> fadeTransitionPage<T>({
  required Widget child,
  String? name,
}) =>
    CustomTransitionPage<T>(
      name: name,
      key: ValueKey(name),
      child: child,
      transitionDuration: _trDuration,
      reverseTransitionDuration: _trDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );

Page<T> cupertinoTransitionPage<T>({
  required Widget child,
  Duration duration = _trDuration,
  String? name,
}) =>
    _CupertinoSlidePage<T>(child: child, duration: duration, name: name);

class _CupertinoSlidePage<T> extends Page<T> {
  const _CupertinoSlidePage({
    required this.child,
    this.duration = _trDuration,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });
  final Widget child;
  final Duration duration;

  @override
  Route<T> createRoute(BuildContext context) => CustomCupertinoPageRoute<T>(
        builder: (_) => child,
        settings: this,
        customDuration: duration,
      );
}

class CustomCupertinoPageRoute<T> extends CupertinoPageRoute<T> {
  CustomCupertinoPageRoute({
    required super.builder,
    super.settings,
    this.customDuration = _trDuration,
  });

  final Duration customDuration;

  @override
  Duration get transitionDuration => customDuration;
}
