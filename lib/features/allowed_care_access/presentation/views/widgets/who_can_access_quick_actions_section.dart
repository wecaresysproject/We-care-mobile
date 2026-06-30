import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/who_care_access/who_care_access_cubit.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_categories_data.dart';

class WhoCanAccessQuickActionsSection extends StatelessWidget {
  const WhoCanAccessQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              final titles = categoriesView.map((e) => e.title).toList();
              context
                  .read<WhoCareAccessCubit>()
                  .setAllDraftModulesPermission('VIEW_ONLY', titles);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColorsManager.mainDarkBlue,
              side: const BorderSide(color: AppColorsManager.mainDarkBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              elevation: 0,
            ),
            child: Text(
              "جعل الكل عرض فقط",
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              final titles = categoriesView.map((e) => e.title).toList();
              context
                  .read<WhoCareAccessCubit>()
                  .setAllDraftModulesPermission('FULL_ACCESS', titles);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColorsManager.mainDarkBlue,
              side: const BorderSide(color: AppColorsManager.mainDarkBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              elevation: 0,
            ),
            child: Text(
              "جعل الكل تحكم كامل",
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
