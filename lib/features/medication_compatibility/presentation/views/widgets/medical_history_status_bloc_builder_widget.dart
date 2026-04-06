import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicalHistoryStatusBlocBuilder extends StatelessWidget {
  const MedicalHistoryStatusBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicinesDataEntryCubit, MedicinesDataEntryState>(
      buildWhen: (previous, current) =>
          previous.medicalHistoryStatus != current.medicalHistoryStatus,
      builder: (context, state) {
        if (state.medicalHistoryStatus == RequestStatus.initial) {
          return const SizedBox.shrink();
        }

        Color backgroundColor;
        Color borderColor;
        Widget icon;
        String text;
        Widget? trailing;

        switch (state.medicalHistoryStatus) {
          case RequestStatus.loading:
            backgroundColor = AppColorsManager.secondaryColor.withOpacity(0.3);
            borderColor = AppColorsManager.mainDarkBlue;
            icon = SizedBox(
              height: 18.w,
              width: 18.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    AppColorsManager.mainDarkBlue),
              ),
            );
            text = "جارٍ تحميل التاريخ الطبي المريض...";
            break;
          case RequestStatus.success:
            // backgroundColor = AppColorsManager.doneColor.withOpacity(0.1);

            // borderColor = AppColorsManager.doneColor;
            // icon = Icon(
            //   Icons.check_circle_outline,
            //   color: AppColorsManager.doneColor,
            //   size: 22.w,
            // );
            // text = "تم تحميل التاريخ الطبي بنجاح";
            final isEmpty = state.userMedicalProfileHistory == null ||
                state.userMedicalProfileHistory!.isHistoryEmpty;
            if (isEmpty) {
              backgroundColor = AppColorsManager.warningColor.withOpacity(0.1);
              borderColor = AppColorsManager.warningColor;
              icon = Icon(
                Icons.error_outline,
                color: AppColorsManager.warningColor,
                size: 22.w,
              );
              text =
                  "يحب ان يكون لديك تاريخ مرضي بداخل التطبيق لإستخدام هذا الموديول";
            } else {
              backgroundColor = AppColorsManager.doneColor.withOpacity(0.1);
              borderColor = AppColorsManager.doneColor;
              icon = Icon(
                Icons.check_circle_outline,
                color: AppColorsManager.doneColor,
                size: 22.w,
              );
              text = "تم تحميل التاريخ الطبي بنجاح";
            }
            break;
          case RequestStatus.failure:
            backgroundColor = AppColorsManager.warningColor.withOpacity(0.1);
            borderColor = AppColorsManager.warningColor;
            icon = Icon(
              Icons.error_outline,
              color: AppColorsManager.warningColor,
              size: 22.w,
            );
            text = "تعذر تحميل التاريخ الطبي";
            trailing = TextButton(
              onPressed: () {
                context
                    .read<MedicinesDataEntryCubit>()
                    .getUserMedicalHistoryDetails();
              },
              child: Text(
                "إعادة المحاولة",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),
            );
            break;
          default:
            return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: borderColor, width: 1.w),
          ),
          child: Row(
            children: [
              icon,
              horizontalSpacing(12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        );
      },
    );
  }
}
