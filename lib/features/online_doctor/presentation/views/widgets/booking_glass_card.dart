import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// الكارت الزجاجى اللى بيتكرر فى شاشة "حجز موعد" — خلفية متدرجة
/// وحدود بتتحول للأزرق الأساسى وهو مختار.
class BookingGlassCard extends StatelessWidget {
  const BookingGlassCard({
    super.key,
    required this.height,
    required this.borderRadius,
    required this.isSelected,
    required this.onTap,
    required this.child,
    this.hasShadowWhenSelected = false,
  });

  /// أقل ارتفاع للكارت — الكارت بيكبر لو النص احتاج مساحة أكتر
  /// على الشاشات الصغيرة بدل ما يحصل overflow.
  final double height;

  final double borderRadius;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;
  final bool hasShadowWhenSelected;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius.r);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // خلفية معتمة تحت التدرج — من غيرها الظل بيبان من ورا الكارت
        // لأن ألوان التدرج شفافة.
        decoration: BoxDecoration(
          color: AppColorsManager.backGroundColor,
          borderRadius: radius,
          boxShadow: isSelected && hasShadowWhenSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: const Offset(0, 2),
                    blurRadius: 3,
                  ),
                ]
              : null,
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: height.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: OnlineDoctorTheme.glassCardGradient,
            borderRadius: radius,
            border: Border.all(
              width: isSelected ? 1.2.w : 0.8.w,
              color: isSelected
                  ? AppColorsManager.mainDarkBlue
                  : OnlineDoctorTheme.glassCardBorder,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
