import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A hand-rolled donut/ring progress indicator (no charting package — see
/// CLAUDE.md's "don't add new packages" rule) showing `value` out of
/// `total`, with the bold value centered inside. Used by the target/achieved
/// cards in [MonthlyExaminationsSectionWidget].
class MonthlyExaminationRingWidget extends StatelessWidget {
  const MonthlyExaminationRingWidget({
    super.key,
    required this.value,
    required this.total,
    required this.ringColor,
    required this.trackColor,
    required this.valueTextStyle,
    this.diameter = 72,
  });

  final int value;
  final int total;
  final Color ringColor;
  final Color trackColor;
  final TextStyle valueTextStyle;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final fraction = total <= 0 ? 0.0 : (value / total).clamp(0.0, 1.0);

    return SizedBox(
      width: diameter.w,
      height: diameter.w,
      child: CustomPaint(
        painter: _ProgressRingPainter(
          fraction: fraction,
          trackColor: trackColor,
          progressColor: ringColor,
          strokeWidth: 7.w,
        ),
        child: Center(child: Text('$value', style: valueTextStyle)),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.fraction,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  /// Fraction in `[0, 1]`.
  final double fraction;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * fraction;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.fraction != fraction ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
