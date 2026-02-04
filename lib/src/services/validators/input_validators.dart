import 'package:flutter/material.dart';

class InputValidators {
  const InputValidators._();

  static bool isValidEmail(String value) {
    const String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return !RegExp(pattern).hasMatch(value);
  }

  static bool isValidPhoneNumber(String value) {
    value = value.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    const String pattern = r'^(?:\+?[0-9]{10,15})$';
    return !RegExp(pattern).hasMatch(value);
  }

  static String? validatePassword(String? password, BuildContext context) {
    final value = password?.trim() ?? "";

    if (value.isEmpty) return '';
    if (value.length < 8) return '';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return '';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return '';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return '';
    }
    // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    //   return "Must contain a special character";
    // }

    if (value.contains(' ')) return '';
    if (RegExp(r'password|123456|qwerty', caseSensitive: false)
        .hasMatch(value)) {
      return '';
    }

    return null;
  }

  static String? validatePasswordsMatch(
      String pass, String conf, BuildContext context) {
    if (pass.trim().isEmpty || conf.trim().isEmpty) {
      return '';
    }

    if (pass != conf) {
      return '';
    }

    return null;
  }

  static bool isTooShort(String value, int length) {
    if (value.length < length) return true;
    return false;
  }

  // static validateOnNumb(String value) {
  //   String pattern = r'[0-9]';
  //   RegExp regExp = RegExp(pattern);

  //   return !regExp.hasMatch(value);
  // }

  // static patternField(String value) {
  //   String pattern =
  //       r'^((?:(?:[^?+*{}()[\]\\|]+|\\.|\[(?:\^?\\.|\^[^\\]|[^\\^])(?:[^\]\\]+|\\.)*\]|\((?:\?[:=!]|\?<[=!]|\?>)?(?1)??\)|\(\?(?:R|[+-]?\d+)\))(?:(?:[?+*]|\{\d*(?:,\d*)?\})[?+]?)?|\|)*)$';
  //   RegExp regExp = RegExp(pattern);
  //   return !regExp.hasMatch(value);
  // }
}
