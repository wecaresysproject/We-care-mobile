import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// صف الزرارين أعلى شاشة "حجوزاتى" — "المواعيد القادمة" هى الشاشة الحالية
/// فبتظهر مختارة، و"السجل السابق" زرار بيفتح شاشته المستقلة.
class MyBookingsHeaderButtons extends StatelessWidget {
  const MyBookingsHeaderButtons({super.key, required this.onHistoryPressed});

  final VoidCallback onHistoryPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: _HeaderButton(
            label: "المواعيد القادمة",
            icon: Icons.calendar_month_rounded,
            isSelected: true,
          ),
        ),
        horizontalSpacing(10),
        Expanded(
          child: _HeaderButton(
            label: "السجل السابق",
            icon: Icons.history_rounded,
            isSelected: false,
            onTap: onHistoryPressed,
          ),
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final contentColor =
        isSelected ? Colors.white : OnlineDoctorTheme.headingColor;

    return Material(
      color: isSelected
          ? AppColorsManager.mainDarkBlue
          : OnlineDoctorTheme.cardSurface,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 44.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? null
                : Border.all(color: OnlineDoctorTheme.fieldBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17.sp, color: contentColor),
              horizontalSpacing(6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font14blackWeight400.copyWith(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    color: contentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
