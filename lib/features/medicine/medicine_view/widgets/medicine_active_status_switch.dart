import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_cubit.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_state.dart';

class MedicineActiveStatusSwitch extends StatelessWidget {
  final String medicineId;

  const MedicineActiveStatusSwitch({
    super.key,
    required this.medicineId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineViewCubit, MedicineViewState>(
      buildWhen: (previous, current) =>
          previous.isActiveMedicine != current.isActiveMedicine ||
          previous.isSwitchLoading != current.isSwitchLoading,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border:
                Border.all(color: AppColorsManager.mainDarkBlue, width: 0.3),
            gradient: const LinearGradient(
              colors: [Color(0xFFECF5FF), Color(0xFFFBFDFD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'حالة استمرارية الدواء',
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  fontSize: 15.sp,
                  color: AppColorsManager.mainDarkBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  if (state.isSwitchLoading)
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          color: AppColorsManager.mainDarkBlue,
                        ),
                      ),
                    ),
                  Switch.adaptive(
                    activeColor: AppColorsManager.mainDarkBlue,
                    value: state.isActiveMedicine,
                    onChanged: state.isSwitchLoading
                        ? null
                        : (value) {
                            context
                                .read<MedicineViewCubit>()
                                .updateMedicineActiveStatus(medicineId, value);
                          },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
