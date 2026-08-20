import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// المعيار اللى بيتم ترتيب الأطباء بيه.
enum DoctorSortField { rating, likes }

/// اتجاه الترتيب — من الأعلى للأقل أو العكس.
enum DoctorSortDirection { descending, ascending }

/// زرار ترتيب على شكل dropdown — بيفتح قائمة بالاتجاهين المتاحين.
class DoctorSortDropdown extends StatelessWidget {
  const DoctorSortDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.descendingLabel,
    required this.ascendingLabel,
    required this.onSelected,
    this.selectedDirection,
  });

  final String label;
  final IconData icon;
  final Color iconColor;

  /// نص خيار "الأعلى" فى القائمة.
  final String descendingLabel;

  /// نص خيار "الأقل" فى القائمة.
  final String ascendingLabel;

  final ValueChanged<DoctorSortDirection> onSelected;

  /// الاتجاه المختار حاليًا — `null` يعنى الترتيب ده مش مفعّل.
  final DoctorSortDirection? selectedDirection;

  bool get _isActive => selectedDirection != null;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DoctorSortDirection>(
      onSelected: onSelected,
      initialValue: selectedDirection,
      padding: EdgeInsets.zero,
      offset: Offset(0, 46.h),
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      itemBuilder: (context) => [
        _menuItem(DoctorSortDirection.descending, descendingLabel),
        _menuItem(DoctorSortDirection.ascending, ascendingLabel),
      ],
      child: Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
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
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        label,
                        maxLines: 1,
                        style: AppTextStyles.font12blackWeight400.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: OnlineDoctorTheme.headingColor,
                        ),
                      ),
                    ),
                  ),
                  horizontalSpacing(4),
                  Icon(icon, size: 13.sp, color: iconColor),
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 16.sp,
              color: OnlineDoctorTheme.headingColor,
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<DoctorSortDirection> _menuItem(
    DoctorSortDirection direction,
    String title,
  ) {
    return PopupMenuItem<DoctorSortDirection>(
      value: direction,
      height: 40.h,
      child: Text(
        title,
        style: AppTextStyles.font12blackWeight400.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: selectedDirection == direction
              ? AppColorsManager.mainDarkBlue
              : OnlineDoctorTheme.headingColor,
        ),
      ),
    );
  }
}
