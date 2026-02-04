import 'package:flutter/material.dart';
import 'package:sample/src/core/theme/colors.dart';

enum AppCheckType { round, square }

class AppCheckBox extends StatelessWidget {
  const AppCheckBox({
    super.key,
    required this.value,
    this.onChanged,
    this.color,
    this.alignment = AlignmentDirectional.center,
    this.type = AppCheckType.square,
  });
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? color;
  final AlignmentGeometry alignment;
  final AppCheckType type;

  @override
  Widget build(BuildContext context) {
    Widget widget;

    switch (type) {
      case AppCheckType.round:
        widget = Stack(alignment: alignment, children: [
          Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                  color: color ?? Colors.transparent,
                  border: Border.all(
                      color: value
                          ? context.colors.cBtnPrimary
                          : context.colors.cBtnDisabled,
                      width: 1.0),
                  borderRadius: BorderRadius.circular(50))),
          value
              ? Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      color: context.colors.cBtnPrimary,
                      borderRadius: BorderRadius.circular(50)))
              : Container()
        ]);
        break;
      case AppCheckType.square:
        widget = Stack(alignment: alignment, children: [
          Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: value
                    ? context.colors.cBtnPrimary
                    : context.colors.cBtnDisabled,
              )),
          value
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Container()
        ]);
    }

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: widget,
    );
  }
}
