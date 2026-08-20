import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

const String _allOption = "الكل";

/// فلتر على شكل dropdown فى شاشة "السجل السابق" —
/// بيفتح قائمة بالقيم المتاحة وأولها "الكل" لمسح الفلتر.
class BookingHistoryFilterDropdown extends StatelessWidget {
  const BookingHistoryFilterDropdown({
    super.key,
    required this.placeholder,
    required this.options,
    required this.onSelected,
    this.icon,
    this.iconAsset,
    this.selectedValue,
  }) : assert(icon != null || iconAsset != null);

  /// النص الظاهر لما مفيش قيمة مختارة — "إسم الطبيب" / "التخصص".
  final String placeholder;

  final List<String> options;

  /// بتتنادى بالقيمة المختارة، و`null` لما المستخدم يختار "الكل".
  final ValueChanged<String?> onSelected;

  final IconData? icon;
  final String? iconAsset;

  /// القيمة المفلتر بيها حاليًا — `null` يعنى الفلتر مش مفعّل.
  final String? selectedValue;

  bool get _isActive => selectedValue != null;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => onSelected(value == _allOption ? null : value),
      initialValue: selectedValue,
      padding: EdgeInsets.zero,
      offset: Offset(0, 46.h),
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      itemBuilder: (context) => [
        _menuItem(_allOption, isSelected: !_isActive),
        for (final option in options)
          _menuItem(option, isSelected: option == selectedValue),
      ],
      child: Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _isActive
                ? AppColorsManager.mainDarkBlue
                : OnlineDoctorTheme.fieldBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColorsManager.mainDarkBlue.withAlpha(12),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon, size: 15.sp, color: AppColorsManager.mainDarkBlue)
            else
              Image.asset(
                iconAsset!,
                width: 14.w,
                height: 14.w,
                fit: BoxFit.contain,
              ),
            horizontalSpacing(6),
            Expanded(
              child: Text(
                selectedValue ?? placeholder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: OnlineDoctorTheme.headingColor,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 17.sp,
              color: OnlineDoctorTheme.headingColor,
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String title, {required bool isSelected}) {
    return PopupMenuItem<String>(
      value: title,
      height: 40.h,
      child: Text(
        title,
        style: AppTextStyles.font12blackWeight400.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isSelected
              ? AppColorsManager.mainDarkBlue
              : OnlineDoctorTheme.headingColor,
        ),
      ),
    );
  }
}
