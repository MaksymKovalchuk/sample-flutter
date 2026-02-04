import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

class AppAutoSizeTextField extends StatefulWidget {
  const AppAutoSizeTextField({
    super.key,
    this.suffixString = "",
    this.fullwidth = true,
    this.textFieldKey,
    this.style,
    this.strutStyle,
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.locale,
    this.wrapWords = true,
    this.overflowReplacement,
    this.semanticsLabel,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    TextInputType? keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlignVertical,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.expands = false,
    this.readOnly = false,
    ToolbarOptions? toolbarOptions,
    this.showCursor,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.onTap,
    this.buildCounter,
    this.scrollPhysics,
    this.scrollController,
    this.minLines,
    this.minWidth,
  })  : textSpan = null,
        smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        assert(minLines == null || minLines > 0),
        assert((minWidth == null && fullwidth == true) || fullwidth == false),
        assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        toolbarOptions = toolbarOptions ??
            (obscureText
                ? const ToolbarOptions(selectAll: true, paste: true)
                : const ToolbarOptions(
                    copy: true, cut: true, selectAll: true, paste: true));
  static const double _defaultFontSize = 14.0;
  static const int noMaxLength = -1;
  final Key? textFieldKey;
  final TextSpan? textSpan;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final double minFontSize;
  final double maxFontSize;
  final double stepGranularity;
  final List<double>? presetFontSizes;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool wrapWords;
  final Widget? overflowReplacement;
  final int? maxLines;
  final String? semanticsLabel;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType smartDashesType;
  final SmartQuotesType smartQuotesType;
  final bool enableSuggestions;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  final ToolbarOptions toolbarOptions;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final DragStartBehavior dragStartBehavior;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final bool? showCursor;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final GestureTapCallback? onTap;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final bool fullwidth;
  final double? minWidth;
  final String suffixString;

  String get data => controller!.text;
  bool get selectionEnabled => enableInteractiveSelection;

  @override
  State<AppAutoSizeTextField> createState() => _AppAutoSizeTextFieldState();
}

class _AppAutoSizeTextFieldState extends State<AppAutoSizeTextField> {
  late double _textSpanWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, size) {
        final defaultTextStyle = DefaultTextStyle.of(context);
        var style = widget.style;

        if (widget.style == null || widget.style!.inherit) {
          style = defaultTextStyle.style.merge(widget.style);
        }

        if (style!.fontSize == null) {
          style =
              style.copyWith(fontSize: AppAutoSizeTextField._defaultFontSize);
        }

        final maxLines = widget.maxLines ?? defaultTextStyle.maxLines;
        _sanityCheck();

        final result = _calculateFontSize(size, style, maxLines);
        final fontSize = result[0] as double;
        final textFits = result[1] as bool;

        Widget textField;
        textField = _buildTextField(fontSize, style, maxLines);

        if (widget.overflowReplacement != null && !textFits) {
          return widget.overflowReplacement!;
        } else {
          return textField;
        }
      });

  @override
  void initState() {
    super.initState();

    widget.controller!.addListener(() {
      if (mounted) setState(() {});
    });
  }

  Widget _buildTextField(double fontSize, TextStyle style, int? maxLines) =>
      SizedBox(
          width: widget.fullwidth
              ? double.infinity
              : math.max(fontSize,
                  _textSpanWidth * MediaQuery.of(context).textScaleFactor),
          child: TextField(
            key: widget.textFieldKey,
            autocorrect: widget.autocorrect,
            autofocus: widget.autofocus,
            buildCounter: widget.buildCounter,
            controller: widget.controller,
            cursorColor: widget.cursorColor,
            cursorRadius: widget.cursorRadius,
            cursorWidth: widget.cursorWidth,
            decoration: widget.decoration,
            dragStartBehavior: widget.dragStartBehavior,
            enabled: widget.enabled,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            enableSuggestions: widget.enableSuggestions,
            expands: widget.expands,
            focusNode: widget.focusNode,
            inputFormatters: widget.inputFormatters,
            keyboardAppearance: widget.keyboardAppearance,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            maxLengthEnforcement:
                widget.maxLengthEnforcement ?? MaxLengthEnforcement.none,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            obscureText: widget.obscureText,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            readOnly: widget.readOnly,
            scrollController: widget.scrollController,
            scrollPadding: widget.scrollPadding,
            scrollPhysics: widget.scrollPhysics,
            selectionHeightStyle: widget.selectionHeightStyle,
            selectionWidthStyle: widget.selectionWidthStyle,
            showCursor: widget.showCursor,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
            strutStyle: widget.strutStyle,
            style: style.copyWith(fontSize: fontSize),
            textAlign: widget.textAlign,
            textAlignVertical: widget.textAlignVertical,
            textCapitalization: widget.textCapitalization,
            textDirection: widget.textDirection,
            textInputAction: widget.textInputAction,
            toolbarOptions: widget.toolbarOptions,
          ));

  List _calculateFontSize(
    BoxConstraints size,
    TextStyle? style,
    int? maxLines,
  ) {
    final span = TextSpan(
        style: widget.textSpan?.style ?? style,
        text: widget.textSpan?.text ?? widget.data,
        children: widget.textSpan?.children,
        recognizer: widget.textSpan?.recognizer);

    final userScale = MediaQuery.textScaleFactorOf(context);
    final presetFontSizes = widget.presetFontSizes?.reversed.toList();

    int left;
    int right;

    if (presetFontSizes == null) {
      final num defaultFontSize =
          style!.fontSize!.clamp(widget.minFontSize, widget.maxFontSize);
      final defaultScale = defaultFontSize * userScale / style.fontSize!;

      if (_checkTextFits(span, defaultScale, maxLines, size)) {
        return [defaultFontSize * userScale, true];
      }

      left = (widget.minFontSize / widget.stepGranularity).floor();
      right = (defaultFontSize / widget.stepGranularity).ceil();
    } else {
      left = 0;
      right = presetFontSizes.length - 1;
    }

    var lastValueFits = false;
    while (left <= right) {
      final mid = (left + (right - left) / 2).toInt();
      double scale;

      if (presetFontSizes == null) {
        scale = mid * userScale * widget.stepGranularity / style!.fontSize!;
      } else {
        scale = presetFontSizes[mid] * userScale / style!.fontSize!;
      }

      if (_checkTextFits(span, scale, maxLines, size)) {
        left = mid + 1;
        lastValueFits = true;
      } else {
        right = mid - 1;
        if (maxLines == null) left = right - 1;
      }
    }

    if (!lastValueFits) right += 1;

    double fontSize;

    if (presetFontSizes == null) {
      fontSize = right * userScale * widget.stepGranularity;
    } else {
      fontSize = presetFontSizes[right] * userScale;
    }

    return [fontSize, lastValueFits];
  }

  bool _checkTextFits(
    TextSpan text,
    double scale,
    int? maxLines,
    BoxConstraints constraints,
  ) {
    double constraintWidth = constraints.maxWidth;
    double constraintHeight = constraints.maxHeight;

    if (widget.decoration.contentPadding != null) {
      constraintWidth -= widget.decoration.contentPadding!.horizontal;
      constraintHeight -= widget.decoration.contentPadding!.vertical;
    }

    if (!widget.wrapWords) {
      final List<String?> words = text.toPlainText().split(RegExp('\\s+'));

      // if (widget.decoration.prefixText != null)
      //   words.add(widget.decoration.prefixText);

      // if (widget.decoration.suffixText != null)
      //   words.add(widget.decoration.suffixText);

      final wordWrapTp = TextPainter(
          textAlign: widget.textAlign,
          textDirection: widget.textDirection ?? TextDirection.ltr,
          textScaleFactor: scale,
          maxLines: words.length,
          locale: widget.locale,
          strutStyle: widget.strutStyle,
          text: WidgetSpan(
              child: RichText(
            text: TextSpan(style: text.style, text: words.join('\n')),
          )));

      wordWrapTp.layout(maxWidth: constraintWidth);

      final double width = (widget.decoration.contentPadding != null)
          ? wordWrapTp.width + widget.decoration.contentPadding!.horizontal
          : wordWrapTp.width;
      _textSpanWidth = math.max(width, widget.minWidth ?? 0);

      if (wordWrapTp.didExceedMaxLines ||
          wordWrapTp.width > constraints.maxWidth) {
        return false;
      }
    }

    String word = text.toPlainText();

    // if (word.length > 0) {
    //   var textContents = text.text ?? '';
    //   word = textContents.replaceAll('\n', ' \n');

    //   if (textContents.codeUnitAt(textContents.length - 1) != 10 &&
    //       textContents.codeUnitAt(textContents.length - 1) != 32) {
    //     word += ' ';
    //   }
    // }

    const String pattern = r'[A-Za-z]';
    final String suffixText =
        widget.suffixString.replaceAll(RegExp(pattern), ' ');

    word += suffixText;

    final tp = TextPainter(
      textAlign: widget.textAlign,
      textDirection: widget.textDirection ?? TextDirection.ltr,
      textScaleFactor: scale,
      maxLines: maxLines,
      locale: widget.locale,
      strutStyle: widget.strutStyle,
      text: TextSpan(
          text: word,
          recognizer: text.recognizer,
          children: text.children,
          semanticsLabel: text.semanticsLabel,
          style: text.style),
    )..layout(maxWidth: constraintWidth);

    final double width = (widget.decoration.contentPadding != null)
        ? tp.width + widget.decoration.contentPadding!.horizontal
        : tp.width;

    final double height = (widget.decoration.contentPadding != null)
        ? tp.height + widget.decoration.contentPadding!.vertical
        : tp.height;

    _textSpanWidth = math.max(width, widget.minWidth ?? 0);

    if (maxLines == null) {
      return (height >= constraintHeight) ? false : true;
    } else {
      return (width >= constraintWidth) ? false : true;
    }
  }

  void _sanityCheck() {
    assert(widget.key == null || widget.key != widget.textFieldKey,
        'Key and textKey cannot be the same.');

    if (widget.presetFontSizes == null) {
      assert(widget.stepGranularity >= 0.1,
          'StepGranularity has to be greater than or equal to 0.1. It is not a good idea to resize the font with a higher accuracy.');
      assert(widget.minFontSize >= 0,
          'MinFontSize has to be greater than or equal to 0.');
      assert(widget.maxFontSize > 0, 'MaxFontSize has to be greater than 0.');
      assert(widget.minFontSize <= widget.maxFontSize,
          'MinFontSize has to be smaller or equal than maxFontSize.');
      assert(widget.minFontSize / widget.stepGranularity % 1 == 0,
          'MinFontSize has to be multiples of stepGranularity.');
      if (widget.maxFontSize != double.infinity) {
        assert(widget.maxFontSize / widget.stepGranularity % 1 == 0,
            'MaxFontSize has to be multiples of stepGranularity.');
      }
    } else {
      assert(widget.presetFontSizes!.isNotEmpty,
          'PresetFontSizes has to be nonempty.');
    }
  }
}
