import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Header label of a prescription table column.
class PrescriptionTableHeaderText extends StatelessWidget {
  const PrescriptionTableHeaderText(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: AppTextStyles.font12blackWeight500.copyWith(
        color: AppColorsManager.prescriptionSubtitleColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Body text of a prescription table cell.
class PrescriptionTableBodyText extends StatelessWidget {
  const PrescriptionTableBodyText(
    this.text, {
    super.key,
    this.isBold = false,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final bool isBold;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        text,
        textAlign: textAlign,
        style: AppTextStyles.font12blackWeight400.copyWith(
          color: AppColorsManager.prescriptionTableText,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          height: 1.4,
        ),
      ),
    );
  }
}

/// Shown inside a section that has no rows yet.
class PrescriptionEmptySectionWidget extends StatelessWidget {
  const PrescriptionEmptySectionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 28.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColorsManager.prescriptionTableDivider),
      ),
      child: Column(
        children: [
          Icon(icon,
              size: 36.r, color: AppColorsManager.prescriptionCardBorder),
          verticalSpacing(8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14blackWeight600.copyWith(
              color: AppColorsManager.prescriptionTitleColor,
            ),
          ),
          verticalSpacing(4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.font12blackWeight400.copyWith(
              color: AppColorsManager.prescriptionSubtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}
