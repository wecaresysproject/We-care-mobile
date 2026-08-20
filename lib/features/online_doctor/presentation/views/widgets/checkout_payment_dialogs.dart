import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// دايالوج انتظار تنفيذ الدفع — مؤشر تحميل دائرى وزرار "إلغاء".
Future<void> showCheckoutLoadingDialog(
  BuildContext context, {
  required VoidCallback onCancel,
}) {
  return _showCheckoutDialog(
    context,
    body: const _GradientRingSpinner(),
    buttonTitle: "إلغاء",
    buttonAreaHeight: 44,
    onButtonTap: onCancel,
  );
}

/// دايالوج نجاح الدفع — علامة صح و"تم بنجاح" وزرار "الذهاب للحجوزات".
Future<void> showCheckoutSuccessDialog(
  BuildContext context, {
  required VoidCallback onGoToBookings,
}) {
  return _showCheckoutDialog(
    context,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/svgs/checkout_success_check_icon.svg",
          width: 62.w,
          height: 50.h,
          fit: BoxFit.contain,
        ),
        verticalSpacing(10),
        Text(
          "تم بنجاح",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeightHelper.bold,
            fontFamily: AppStrings.cairoFontFamily,
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
      ],
    ),
    buttonTitle: "الذهاب للحجوزات",
    buttonAreaHeight: 50,
    onButtonTap: onGoToBookings,
  );
}

Future<void> _showCheckoutDialog(
  BuildContext context, {
  required Widget body,
  required String buttonTitle,
  required double buttonAreaHeight,
  required VoidCallback onButtonTap,
}) {
  return showDialog<void>(
    context: context,
    // الفلو بيتقفل من جوه الدايالوج نفسه — مش من الضغط على الخلفية.
    barrierDismissible: false,
    // فى التصميم الشاشة اللى ورا الدايالوج بتتغطى بطبقة بيضاء خفيفة مش سوداء.
    barrierColor: Colors.white.withValues(alpha: 0.4),
    builder: (context) => Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
      child: SizedBox(
        width: 270.w,
        height: 209.h,
        child: Column(
          children: [
            Expanded(child: Center(child: body)),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE6E4EA)),
            SizedBox(
              height: buttonAreaHeight.h,
              width: double.infinity,
              child: InkWell(
                onTap: onButtonTap,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32.r),
                ),
                child: Center(
                  child: Text(
                    buttonTitle,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeightHelper.semiBold,
                      fontFamily: AppStrings.cairoFontFamily,
                      color: AppColorsManager.mainDarkBlue,
                      height: 27 / 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// حلقة تحميل بتلف — لونها متدرج من الفاتح للأزرق الأساسى زى التصميم.
class _GradientRingSpinner extends StatefulWidget {
  const _GradientRingSpinner();

  @override
  State<_GradientRingSpinner> createState() => _GradientRingSpinnerState();
}

class _GradientRingSpinnerState extends State<_GradientRingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112.w,
      height: 112.w,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        ),
        child: const CustomPaint(painter: _GradientRingPainter()),
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  const _GradientRingPainter();

  static const _strokeWidth = 13.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [Color(0xFFEDF2F8), AppColorsManager.mainDarkBlue],
        transform: GradientRotation(-math.pi / 2),
      ).createShader(rect);

    canvas.drawArc(
      rect.deflate(_strokeWidth / 2),
      -math.pi / 2,
      2 * math.pi * 0.8,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GradientRingPainter oldDelegate) => false;
}
