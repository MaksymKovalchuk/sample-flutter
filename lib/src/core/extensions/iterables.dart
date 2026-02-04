import 'package:flutter/material.dart';

// Extension on Iterable<E> that provides a method to find the first element
// satisfying a given predicate or return null if no such element exists.
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final E element in this) {
      if (test(element)) return element;
    }

    return null;
  }
}

// A class that extends ValueNotifier to combine multiple ValueNotifier instances
// into a single notifier of a list of values.
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

// Extension on Map<K, V> providing a method to remove entries based on a condition.
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
