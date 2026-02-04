import 'package:sample/src/core/localization/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// List of extensions for [BuildContext]
extension ContextExtension on BuildContext {
  T di<T extends Object>() => GetIt.instance<T>();

  /// Obtain the nearest widget of the given type T,
  /// which must be the type of a concrete [InheritedWidget] subclass,
  /// and register this build context with that widget such that
  /// when that widget changes (or a new widget of that type is introduced,
  /// or the widget goes away), this build context is rebuilt so that it can
  /// obtain new values from that widget.
  T? inhMaybeOf<T extends InheritedWidget>({bool listen = true}) => listen
      ? dependOnInheritedWidgetOfExactType<T>()
      : getInheritedWidgetOfExactType<T>();

  /// Obtain the nearest widget of the given type T,
  /// which must be the type of a concrete [InheritedWidget] subclass,
  /// and register this build context with that widget such that
  /// when that widget changes (or a new widget of that type is introduced,
  /// or the widget goes away), this build context is rebuilt so that it can
  /// obtain new values from that widget.
  T inhOf<T extends InheritedWidget>({bool listen = true}) =>
      inhMaybeOf<T>(listen: listen) ??
      (throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a $T of the exact type',
        'out_of_scope',
      ));

  /// Maybe inherit specific aspect from [InheritedModel].
  T? maybeInheritFrom<A extends Object, T extends InheritedModel<A>>(
    A? aspect,
  ) =>
      InheritedModel.inheritFrom<T>(this, aspect: aspect);

  /// Inherit specific aspect from [InheritedModel].
  T inheritFrom<A extends Object, T extends InheritedModel<A>>({A? aspect}) =>
      InheritedModel.inheritFrom<T>(this, aspect: aspect) ??
      (throw ArgumentError(
        'Out of scope, not found inherited model '
            'a $T of the exact type',
        'out_of_scope',
      ));
}

extension LocalizationExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}

extension MediaQuerySizeExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomInset => MediaQuery.of(this).viewInsets.bottom;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
}
