import 'dart:math';

import 'package:flutter/material.dart';


class WavesIndicator extends AnimatedWidget {
  const WavesIndicator({
    required this.color,
    required this.child,
    this.opacityStep = 0.05,
    this.radiusStep = 10,
    this.stroke = 2,
    required Animation<double> listenable,
    super.key,
  }) : super(listenable: listenable);

  final Widget child;
  final Color color;
  final double radiusStep;
  final double opacityStep;
  final double stroke;

  @override
  Animation<double> get listenable => super.listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircleWavePainter(
        color: color,
        minRadius: listenable.value,
        opacityStep: opacityStep,
        radiusStep: radiusStep,
        stroke: stroke,
      ),
      child: Center(
        child: child,
      ),
    );
  }
}

class CircleWavePainter extends CustomPainter {
  final Color color;
  final double radiusStep;
  final double opacityStep;
  final double stroke;
  final double minRadius;

  CircleWavePainter({
    required this.color,
    required this.minRadius,
    required this.opacityStep,
    required this.radiusStep,
    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final maxRadius = center.distance;

    var currentRadius = minRadius;
    var opacity = color.opacity;

    while (currentRadius < maxRadius) {
      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..isAntiAlias = true;

      canvas.drawCircle(center, currentRadius, paint);
      currentRadius += radiusStep;
      opacity -= opacityStep;
      opacity = max(opacity, 0);
    }
  }

  @override
  bool shouldRepaint(CircleWavePainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CircleWavePainter &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          radiusStep == other.radiusStep &&
          opacityStep == other.opacityStep &&
          stroke == other.stroke &&
          minRadius == other.minRadius;

  @override
  int get hashCode =>
      color.hashCode ^
      radiusStep.hashCode ^
      opacityStep.hashCode ^
      stroke.hashCode ^
      minRadius.hashCode;
}
