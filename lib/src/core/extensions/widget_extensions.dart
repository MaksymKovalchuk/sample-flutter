import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension WidgetPaddingMarginExtension on Widget {
  // Padding
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: this,
  );

  Widget paddingSymmetric({double vertical = 0, double horizontal = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: this,
      );

  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  // Margin (wrap with Container)
  Widget marginOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Container(
    margin: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
    child: this,
  );

  Widget marginSymmetric({double vertical = 0, double horizontal = 0}) =>
      Container(
        margin: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: this,
      );

  Widget marginAll(double value) =>
      Container(margin: EdgeInsets.all(value), child: this);
}

extension ListNullSafeAdd<T> on List<T> {
  void addNonNull(T? element) {
    if (element != null) {
      add(element);
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

// "1000" -> "1,000"
String comaFormat(String value) => value.replaceAllMapped(
  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
  (m) => '${m[1]},',
);

String zeroFormat(String value) =>
    value.replaceAll(RegExp(r'([.]*00)(?!.*\d)'), '');
