import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';

class ModulesPermissionsSummaryCard extends StatelessWidget {
  final VoidCallback onTap;

  const ModulesPermissionsSummaryCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccessManagementCubit, AccessManagementState>(
      buildWhen: (previous, current) =>
          previous.modulePermissions != current.modulePermissions,
      builder: (context, state) {
        final selectedModules = state.modulePermissions.values.toList();
        int fullAccess = 0;
        int viewOnly = 0;

        for (final module in selectedModules) {
          if (module.isEnabledModule) {
            if (module.permission == 'FULL_ACCESS') {
              fullAccess++;
            } else {
              viewOnly++;
            }
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "إدارة الصلاحيات",
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            verticalSpacing(8),
            GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "حدد مستوى الوصول لكل جزء من الملف الطبي",
                            style: AppTextStyles.font14blackWeight400.copyWith(
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                          if (selectedModules.isNotEmpty) ...[
                            verticalSpacing(12),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16.sp,
                                  color: Colors.green,
                                ),
                                horizontalSpacing(6),
                                Text(
                                  "تم تخصيص الصلاحيات",
                                  style: AppTextStyles.font14blackWeight400
                                      .copyWith(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                            verticalSpacing(10),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF6ED),
                                    borderRadius: BorderRadius.circular(
                                      20.r,
                                    ),
                                  ),
                                  child: Text(
                                    '$fullAccess تحكم كامل',
                                    style: AppTextStyles.font14blackWeight400
                                        .copyWith(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F6F8),
                                    borderRadius: BorderRadius.circular(
                                      20.r,
                                    ),
                                  ),
                                  child: Text(
                                    '$viewOnly عرض فقط',
                                    style: AppTextStyles.font14blackWeight400
                                        .copyWith(
                                      color: Colors.blueGrey.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    horizontalSpacing(12),
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
