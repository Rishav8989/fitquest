import 'package:flutter/material.dart';

/// Wraps a child so it scales down slightly on tap for a responsive, interactive feel.
class AnimatedScaleTap extends StatefulWidget {
  const AnimatedScaleTap({
    super.key,
    required this.onTap,
    required this.child,
    this.scaleDown = 0.96,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
  });

  final VoidCallback? onTap;
  final Widget child;
  final double scaleDown;
  final Duration duration;
  final Curve curve;

  @override
  State<AnimatedScaleTap> createState() => _AnimatedScaleTapState();
}

class _AnimatedScaleTapState extends State<AnimatedScaleTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scale = Tween<double>(begin: 1, end: widget.scaleDown).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
