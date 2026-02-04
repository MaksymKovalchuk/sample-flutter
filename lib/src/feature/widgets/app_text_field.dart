import 'package:sample/src/core/extensions/widget_extensions.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/theme/text_theme.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.maxLines = 1,
    this.style,
    this.verticalPadding = 18,
    this.fillColor,
    this.rightWidget,
    this.leftWidget,
    this.keyboardType = TextInputType.text,
    this.capitalization = TextCapitalization.none,
    this.borderColor,
    this.focusNode,
    this.onDone,
    this.textAlign = TextAlign.start,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.formKey,
    this.inputFormatters,
    this.labelsText = "",
    this.readOnly = false,
    this.maxLength,
    this.onChanged,
    this.hasClearButton = false,
    this.autofocus = false,
    this.onTap,
    this.autovalidateMode,
  });
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final Widget? rightWidget;
  final Widget? leftWidget;
  final String labelsText;
  final bool obscureText;
  final int maxLines;
  final double verticalPadding;
  final TextCapitalization capitalization;
  final Color? borderColor;
  final Color? fillColor;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final VoidCallback? onDone;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final GlobalKey<FormState>? formKey;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final int? maxLength;
  final Function(String)? onChanged;
  final bool hasClearButton;
  final TextStyle? style;
  final bool autofocus;
  final void Function()? onTap;
  final AutovalidateMode? autovalidateMode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  static const double _borderRadius = 10;
  static const double _paddingSide = 12;
  static const double _borderWidth = 1.0;

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (widget.labelsText.isNotEmpty)
          Text(" ${widget.labelsText}", style: context.smallText(weight: 520))
              .marginOnly(bottom: 16),
        Form(
          key: widget.formKey,
          child: TextFormField(
              onTap: widget.onTap,
              validator: widget.validator,
              textInputAction: widget.textInputAction,
              textAlign: widget.textAlign,
              focusNode: widget.focusNode,
              onEditingComplete: widget.onDone,
              autocorrect: false,
              enableSuggestions: false,
              onChanged: (value) {
                if (widget.onChanged !=
                        null // &&  value != widget.controller.text
                    ) {
                  widget.onChanged!(value);
                }
                setState(() {});
              },
              textCapitalization: widget.capitalization,
              maxLines: widget.maxLines,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              autofocus: widget.autofocus,
              minLines: 1,
              maxLength: widget.maxLength,
              readOnly: widget.readOnly,
              cursorColor: context.colors.cTextPrimary,
              inputFormatters: widget.inputFormatters,
              textAlignVertical: TextAlignVertical.center,
              style: widget.style ?? context.lSmallText(),
              autovalidateMode: widget.autovalidateMode,
              decoration: InputDecoration(
                  isCollapsed: true,
                  filled: true,
                  fillColor: widget.fillColor ?? context.colors.cBgBlock,
                  errorMaxLines: 3,
                  errorStyle: StyleManager.styleText(fXSmall12,
                      color: context.colors.cBtnSell, height: 1.4),
                  helperStyle: context.lSmallSubText(),
                  hintStyle: context.lSmallSubText(),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      borderSide: BorderSide(
                          color: context.colors.cBtnSell, width: _borderWidth)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      borderSide: BorderSide(
                          color: context.colors.cBtnSell, width: _borderWidth)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      borderSide: BorderSide(
                          color:
                              widget.borderColor ?? context.colors.cBtnPrimary,
                          width: _borderWidth)),
                  suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // if (widget.controller.text.isNotEmpty &&
                        //     widget.hasClearButton)
                        //   ImageButton(
                        //       size: 24,
                        //       margin: EdgeInsets.zero,
                        //       image: AppImages.close,
                        //       onPressed: () {
                        //         widget.controller.clear();
                        //         setState(() {});
                        //       }).marginOnly(top: 2),
                        widget.rightWidget ?? Container()
                      ]).marginOnly(right: _paddingSide),
                  suffixIconConstraints: BoxConstraints(
                      maxHeight: widget.rightWidget == null ? 28 : 48),
                  prefixIcon: widget.leftWidget
                      ?.marginOnly(left: _paddingSide, right: 6),
                  prefixIconConstraints: const BoxConstraints(maxHeight: 24),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      borderSide: BorderSide(
                          color: widget.fillColor ?? Colors.transparent,
                          width: _borderWidth)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_borderRadius)),
                  contentPadding: EdgeInsets.fromLTRB(
                      widget.leftWidget == null ? _paddingSide : 8,
                      widget.verticalPadding,
                      widget.rightWidget != null ? _paddingSide : 0,
                      widget.verticalPadding),
                  hintText: widget.hintText)),
        )
      ]);
}
