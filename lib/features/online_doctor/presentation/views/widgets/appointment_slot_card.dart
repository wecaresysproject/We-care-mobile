import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_slot_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// كارت توقيت واحد فى صف توقيتات اليوم المختار —
/// اليوم نفسه بيتختار من صف الأيام اللى فوق فمش بيتكرر هنا.
class AppointmentSlotCard extends StatelessWidget {
  const AppointmentSlotCard({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  final AppointmentTimeSlot slot;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90.w,
        // أقل ارتفاع بس — الكارت بيكبر لو الخط احتاج مساحة أكبر.
        constraints: BoxConstraints(minHeight: 104.h),
        // بننقص عرض الحد من الـ padding عشان المحتوى يقع على بعد 10 و 12
        // من حافة الكارت بالظبط زى التصميم.
        padding: EdgeInsets.only(
          top: 12.h - 1.8.w,
          left: 10.w - 1.8.w,
          right: 10.w - 1.8.w,
          bottom: 8.h,
        ),
        decoration: BoxDecoration(
          gradient: OnlineDoctorTheme.glassCardGradient,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            width: 1.8.w,
            color: isSelected
                ? AppColorsManager.mainDarkBlue
                : OnlineDoctorTheme.glassCardBorder,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SlotTimeRange(slot: slot),
            verticalSpacing(12),
            _SlotCtaButton(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _SlotTimeRange extends StatelessWidget {
  const _SlotTimeRange({required this.slot});

  final AppointmentTimeSlot slot;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: AppStrings.cairoFontFamily,
      color: AppColorsManager.textColor,
      height: 20 / 14,
      letterSpacing: 0.14,
    );

    return Column(
      children: [
        Text("من  ${slot.fromTime}", textAlign: TextAlign.center, style: style),
        verticalSpacing(1),
        Text("إلى  ${slot.toTime}", textAlign: TextAlign.center, style: style),
      ],
    );
  }
}

/// زرار الكارت — "احجز" وهو غير مختار و"تم ✓" بعد الاختيار.
class _SlotCtaButton extends StatelessWidget {
  const _SlotCtaButton({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColorsManager.mainDarkBlue,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isSelected ? "تم" : "احجز",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeightHelper.bold,
              fontFamily: AppStrings.cairoFontFamily,
              color: AppColorsManager.backGroundColor,
              height: 20 / 14,
              letterSpacing: 0.14,
            ),
          ),
          if (isSelected) ...[
            horizontalSpacing(4),
            SvgPicture.asset(
              "assets/svgs/booking_slot_check_icon.svg",
              width: 11.w,
            ),
          ],
        ],
      ),
    );
  }
}
