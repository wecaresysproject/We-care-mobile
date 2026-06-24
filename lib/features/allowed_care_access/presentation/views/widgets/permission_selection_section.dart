import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/permission_option_card.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_categories_data.dart';

class PermissionSelectionSection extends StatelessWidget {
  const PermissionSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AccessManagementCubit, AccessManagementState, String>(
      selector: (state) => state.selectedPermission,
      builder: (context, selectedPermission) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الصلاحية المطلوبة علي الموديولات',
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: PermissionOptionCard(
                    isSelected: selectedPermission == 'FULL_ACCESS',
                    title: 'تحكم كامل',
                    subtitle: 'عرض + تعديل',
                    icon: Icons.edit_outlined,
                    onTap: () {
                      context
                          .read<AccessManagementCubit>()
                          .updateSelectedPermission('FULL_ACCESS');
                      final titles =
                          categoriesView.map((e) => e.title).toList();

                      context
                          .read<AccessManagementCubit>()
                          .setAllModulesPermission('FULL_ACCESS', titles);
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: PermissionOptionCard(
                    isSelected: selectedPermission == 'VIEW_ONLY',
                    title: 'عرض فقط',
                    subtitle: 'اطلاع فقط',
                    icon: Icons.remove_red_eye_outlined,
                    onTap: () {
                      context
                          .read<AccessManagementCubit>()
                          .updateSelectedPermission('VIEW_ONLY');
                      final titles =
                          categoriesView.map((e) => e.title).toList();
                      context
                          .read<AccessManagementCubit>()
                          .setAllModulesPermission('VIEW_ONLY', titles);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
