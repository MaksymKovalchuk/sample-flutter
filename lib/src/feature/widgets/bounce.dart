import 'package:flutter/material.dart';

class Bounce extends StatefulWidget {
  const Bounce({
    super.key,
    required this.child,
    this.duration,
    required this.onPressed,
  });
  final VoidCallback onPressed;
  final Widget child;
  final Duration? duration;

  @override
  State<Bounce> createState() => _BounceState();
}

class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin {
  late double _scale;

  late AnimationController _animate;
  VoidCallback get onPressed => widget.onPressed;
  Duration get userDuration =>
      widget.duration ?? const Duration(milliseconds: 100);

  @override
  void initState() {
    _animate = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
        lowerBound: 0.0,
        upperBound: 0.2)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animate.value;
    return InkWell(
        onTap: _onTap,
        child: Transform.scale(scale: _scale, child: widget.child));
  }

  void _onTap() {
    _animate.forward();

    Future.delayed(userDuration, () {
      if (mounted) {
        _animate.reverse();
        onPressed();
      }
    });
  }

  @override
  void dispose() {
    _animate.stop();
    _animate.dispose();
    super.dispose();
  }
}
