import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// كارت ملخص الحجز أعلى شاشة "الدفع" — سعر الحجز ورسوم البرنامج
/// وتحتهم خط مقطّع ثم الإجمالى.
class CheckoutSummaryCard extends StatelessWidget {
  const CheckoutSummaryCard({
    super.key,
    required this.bookingPrice,
    required this.programFee,
  });

  final int bookingPrice;
  final int programFee;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
      decoration: BoxDecoration(
        gradient: OnlineDoctorTheme.sectionHeaderGradient,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        children: [
          _SummaryRow(label: "سعر الحجز", value: bookingPrice),
          verticalSpacing(8),
          _SummaryRow(label: "رسوم البرنامج", value: programFee),
          SizedBox(
            height: 24.h,
            width: double.infinity,
            child: CustomPaint(painter: _DashedLinePainter()),
          ),
          verticalSpacing(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("الاجمالى", style: _totalStyle),
              Text("${bookingPrice + programFee}", style: _totalStyle),
            ],
          ),
        ],
      ),
    );
  }

  static final _totalStyle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.semiBold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.mainDarkBlue,
    height: 27 / 20,
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeightHelper.medium,
            fontFamily: AppStrings.cairoFontFamily,
            color: AppColorsManager.textColor,
            height: 20 / 16,
            letterSpacing: 0.16,
          ),
        ),
        Text(
          "$value",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeightHelper.medium,
            fontFamily: AppStrings.cairoFontFamily,
            color: AppColorsManager.textColor,
            height: 25 / 18,
          ),
        ),
      ],
    );
  }
}

/// الخط المقطّع الفاصل قبل الإجمالى.
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 11.0;
    const dashGap = 9.0;
    final paint = Paint()
      ..color = AppColorsManager.textfieldOutsideBorderColor
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    for (double x = 0; x < size.width - dashWidth; x += dashWidth + dashGap) {
      canvas.drawLine(
        Offset(x, centerY),
        Offset(x + dashWidth, centerY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) => false;
}
