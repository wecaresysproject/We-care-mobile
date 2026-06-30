import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_access_request_details_response.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';

class PermissionExplanationCard extends StatelessWidget {
  final List<PermissionCapabilityModel> capabilities;

  const PermissionExplanationCard({super.key, required this.capabilities});

  Widget _buildExpansionItem(
      BuildContext context, PermissionCapabilityModel cap) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.only(right: 28.w, bottom: 8.h),
        iconColor: AppColorsManager.mainDarkBlue,
        collapsedIconColor: AppColorsManager.mainDarkBlue,
        title: Row(
          children: [
            Icon(
              cap.allowed ? Icons.check_circle : Icons.cancel,
              color: cap.allowed
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFE65100),
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                cap.title,
                style: AppTextStyles.font14blackWeight400.copyWith(
                  color: Colors.grey.shade800,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        children: cap.capabilities.map((subCap) {
          return Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Icon(
                    Icons.check,
                    color: AppColorsManager.mainDarkBlue,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    subCap,
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      color: Colors.grey.shade700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (capabilities.isEmpty) return const SizedBox.shrink();

    return BlocBuilder<AccessManagementCubit, AccessManagementState>(
      builder: (context, state) {
        final modulePermissions = state.modulePermissions.values.toList();

        bool isFullAccess = false;
        bool isViewOnly = false;
        bool isPartial = false;

        if (modulePermissions.isNotEmpty) {
          bool allEnabled = modulePermissions.every((m) => m.isEnabledModule);
          bool allFull =
              modulePermissions.every((m) => m.permission == 'FULL_ACCESS');
          bool allView =
              modulePermissions.every((m) => m.permission == 'VIEW_ONLY');

          if (allEnabled && allFull) {
            isFullAccess = true;
          } else if (allEnabled && allView) {
            isViewOnly = true;
          } else {
            isPartial = true;
          }
        }

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD), // Light blue tint
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppColorsManager.mainDarkBlue, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'ما الذي سيستطيع فعله؟',
                    style: AppTextStyles.font14BlueWeight700.copyWith(
                      color: AppColorsManager.mainDarkBlue,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ...capabilities.asMap().entries.map((entry) {
                final index = entry.key;
                final cap = entry.value;

                bool isAllowed = cap.allowed;
                if (modulePermissions.isNotEmpty) {
                  if (index == 0) {
                    isAllowed = isFullAccess;
                  } else if (index == 1)
                    isAllowed = isViewOnly;
                  else if (index == 2) isAllowed = isPartial;
                }

                final updatedCap = PermissionCapabilityModel(
                  title: cap.title,
                  allowed: isAllowed,
                  capabilities: cap.capabilities,
                );

                return _buildExpansionItem(context, updatedCap);
              }),
            ],
          ),
        );
      },
    );
  }
}
