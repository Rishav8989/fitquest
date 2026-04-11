import 'package:flutter/material.dart';

/// A progress bar that animates when [percent] changes.
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.percent,
    required this.progressColor,
    this.backgroundColor,
    this.height = 12,
    this.radius = 6,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
  });

  final double percent;
  final Color progressColor;
  final Color? backgroundColor;
  final double height;
  final double radius;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? progressColor.withOpacity(0.2);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: percent.clamp(0.0, 1.0)),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: bg,
          ),
          child: FractionallySizedBox(
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: progressColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A widget that sizes its child to a fraction of the parent's width.
class FractionallySizedBox extends StatelessWidget {
  const FractionallySizedBox({
    super.key,
    required this.widthFactor,
    required this.child,
  });

  final double widthFactor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * widthFactor,
          child: child,
        );
      },
    );
  }
}
