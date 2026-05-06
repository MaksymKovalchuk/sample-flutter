import 'package:flutter/material.dart';

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }

    return null;
  }
}

class CombinedValueNotifier<T> extends ValueNotifier<List<T>> {
  CombinedValueNotifier(List<ValueNotifier<T>> valueNotifiers)
    : super(valueNotifiers.map((notifier) => notifier.value).toList()) {
    for (var i = 0; i < valueNotifiers.length; i++) {
      valueNotifiers[i].addListener(() {
        value = List.from(value);
        value[i] = valueNotifiers[i].value;
        notifyListeners();
      });
    }
  }
}

extension MapExtensions<K, V> on Map<K, V> {
  void removeWhere(bool Function(K key, V value) test) {
    final keysToRemove = <K>[];

    forEach((key, value) {
      if (test(key, value)) {
        keysToRemove.add(key);
      }
    });

    for (final key in keysToRemove) {
      remove(key);
    }
  }
}
