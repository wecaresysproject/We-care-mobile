import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

/// A hand-rolled donut/ring progress indicator (no charting package — see
/// CLAUDE.md's "don't add new packages" rule) showing the current month's
/// completion percentage: a green arc over a light track, with the bold
/// percentage and a "من الهدف" caption centered inside.
class MonthlyGoalProgressRingWidget extends StatelessWidget {
  const MonthlyGoalProgressRingWidget({
    super.key,
    required this.percentage,
    this.diameter = 120,
  });

  /// Completion percentage, expected in `[0, 100]`.
  final int percentage;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final clamped = percentage.clamp(0, 100);

    return SizedBox(
      width: diameter.w,
      height: diameter.w,
      child: CustomPaint(
        painter: _ProgressRingPainter(
          percentage: clamped / 100,
          trackColor: AppColorsManager.shimmerBase,
          progressColor: AppColorsManager.doneColor,
          strokeWidth: 10.w,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$clamped%',
                style: AppTextStyles.font20blackWeight700
                    .copyWith(color: AppColorsManager.doneColor),
              ),
              verticalSpacing(2),
              Text(
                localization.monthlyExaminationTargetFormOfTarget,
                style: AppTextStyles.font12blackWeight400,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.percentage,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  /// Fraction in `[0, 1]`.
  final double percentage;
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
    final sweepAngle = 2 * math.pi * percentage;

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
    return oldDelegate.percentage != percentage ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
