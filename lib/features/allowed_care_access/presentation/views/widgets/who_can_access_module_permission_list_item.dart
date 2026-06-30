import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/who_care_access/who_care_access_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/who_care_access/who_care_access_state.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_category_model.dart';

class WhoCanAccessModulePermissionListItem extends StatelessWidget {
  final MedicalCategoryModel category;

  const WhoCanAccessModulePermissionListItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<WhoCareAccessCubit, WhoCareAccessState>(
            buildWhen: (previous, current) =>
                previous.draftModulePermissions[category.title] !=
                current.draftModulePermissions[category.title],
            builder: (context, state) {
              final moduleDto = state.draftModulePermissions[category.title];
              final currentPermission = moduleDto?.permission ?? 'VIEW_ONLY';
              final isEnabled = moduleDto?.isEnabledModule ?? false;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color:
                              AppColorsManager.mainDarkBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Image.asset(category.image),
                      ),
                      horizontalSpacing(12),
                      Expanded(
                        child: Text(
                          category.title,
                          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColorsManager.mainDarkBlue,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: isEnabled,
                        activeColor: AppColorsManager.mainDarkBlue,
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<WhoCareAccessCubit>()
                                .toggleDraftModuleEnabled(category.title, value);
                          }
                        },
                      ),
                    ],
                  ),
                  verticalSpacing(16),
                  Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        _buildSegmentButton(
                          context: context,
                          title: "عرض فقط",
                          isSelected: currentPermission == 'VIEW_ONLY',
                          isEnabled: isEnabled,
                          onTap: () {
                            if (!isEnabled) {
                              showError(
                                  'الرجاء تفعيل الموديول أولاً لتعديل الصلاحية');
                              return;
                            }
                            context
                                .read<WhoCareAccessCubit>()
                                .updateDraftModulePermission(
                                    category.title, 'VIEW_ONLY');
                          },
                        ),
                        _buildSegmentButton(
                          context: context,
                          title: "تحكم كامل",
                          isSelected: currentPermission == 'FULL_ACCESS',
                          isEnabled: isEnabled,
                          onTap: () {
                            if (!isEnabled) {
                              showError(
                                  'الرجاء تفعيل الموديول أولاً لتعديل الصلاحية');
                              return;
                            }
                            context
                                .read<WhoCareAccessCubit>()
                                .updateDraftModulePermission(
                                    category.title, 'FULL_ACCESS');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    final bool displaySelected = isEnabled && isSelected;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: displaySelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: displaySelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTextStyles.font14blackWeight400.copyWith(
              color: !isEnabled
                  ? Colors.grey.shade400
                  : (displaySelected
                      ? AppColorsManager.mainDarkBlue
                      : Colors.grey.shade600),
              fontWeight: displaySelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
