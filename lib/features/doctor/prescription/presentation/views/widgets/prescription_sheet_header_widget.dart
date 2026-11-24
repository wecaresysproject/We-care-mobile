import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Drag handle + icon, title and close button at the top of the
/// prescription bottom sheets.
class PrescriptionSheetHeaderWidget extends StatelessWidget {
  const PrescriptionSheetHeaderWidget({
    super.key,
    required this.title,
    this.icon = Icons.medication_outlined,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 44.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColorsManager.prescriptionCardBorder,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        verticalSpacing(12),
        Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: const BoxDecoration(
                color: AppColorsManager.prescriptionMedicinesHeaderBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20.r,
                color: AppColorsManager.prescriptionMedicinesAccent,
              ),
            ),
            horizontalSpacing(10),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: AppColorsManager.prescriptionTitleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              tooltip: "إغلاق",
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close,
                color: AppColorsManager.prescriptionTitleColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
