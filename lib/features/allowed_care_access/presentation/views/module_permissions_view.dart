import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_categories_data.dart';

import 'widgets/module_permission_list_item.dart';
import 'widgets/quick_actions_section.dart';
import 'widgets/save_permissions_bottom_bar.dart';

class ModulePermissionsScreen extends StatelessWidget {
  const ModulePermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Row(
                  children: [
                    Text(
                      "تخصيص صلاحيات الموديولات",
                      style: AppTextStyles.font22MainBlueWeight700.copyWith(
                        color: AppColorsManager.mainDarkBlue,
                        fontSize: 18.sp,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color:
                              AppColorsManager.mainDarkBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: AppColorsManager.mainDarkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "اختر مستوى الوصول لكل موديول طبي بشكل مستقل",
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              verticalSpacing(24),

              // Quick Actions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: QuickActionsSection(),
              ),
              verticalSpacing(16),

              // Modules List
              Expanded(
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  itemCount: categoriesView.length,
                  separatorBuilder: (context, index) => verticalSpacing(12),
                  itemBuilder: (context, index) {
                    final category = categoriesView[index];
                    return ModulePermissionListItem(category: category);
                  },
                ),
              ),

              // Bottom Bar
              const SavePermissionsBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
