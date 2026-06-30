import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/who_care_access/who_care_access_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/who_care_access/who_care_access_state.dart';

class WhoCanAccessSavePermissionsBottomBar extends StatelessWidget {
  const WhoCanAccessSavePermissionsBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: BlocConsumer<WhoCareAccessCubit, WhoCareAccessState>(
            listener: (context, state) {
              if (state.savePermissionsStatus == RequestStatus.success) {
                // Return to the previous screen when saving succeeds
                Navigator.of(context).pop(true);
              }
            },
            builder: (context, state) {
              final isLoading =
                  state.savePermissionsStatus == RequestStatus.loading;
              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        context
                            .read<WhoCareAccessCubit>()
                            .updateAccessPermissions();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsManager.mainDarkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "حفظ الصلاحيات",
                        style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
