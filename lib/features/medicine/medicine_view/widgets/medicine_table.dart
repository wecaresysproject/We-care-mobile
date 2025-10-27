

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/medicine_view/Presention/medicine_details_view.dart';
import 'package:we_care/features/medicine/medicine_view/Presention/similar_date_medicine_details_view.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_cubit.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_state.dart';

class MedicineTable extends StatelessWidget {
  const MedicineTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineViewCubit, MedicineViewState>(
      buildWhen: (previous, current) =>
          previous.userMedicines != current.userMedicines ||
          previous.requestStatus != current.requestStatus,
      builder: (context, state) {
        if (state.userMedicines.isEmpty &&
            state.requestStatus == RequestStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.userMedicines.isEmpty &&
            state.requestStatus == RequestStatus.success) {
          return Center(
            child: Text(
              "لا توجد بيانات",
              style: AppTextStyles.font22MainBlueWeight700,
            ),
          );
        } else if (state.requestStatus == RequestStatus.failure) {
          return Center(
            child: Text(
              state.responseMessage,
              style: AppTextStyles.font22MainBlueWeight700,
            ),
          );
        }
        return SingleChildScrollView(
          scrollDirection: Axis.vertical, // Allow scrolling if needed
          child: DataTable(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            headingRowColor: WidgetStateProperty.all(
                AppColorsManager.mainDarkBlue), // Header Background Color

            columnSpacing: 6.w,
            dataRowHeight: 60.h,
            horizontalMargin: 5.w,
            showBottomBorder: true,
            border: TableBorder.all(
              borderRadius: BorderRadius.circular(16.r),
              color: Color(0xff909090),
              width: .3,
            ),
            columns: [
              DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "التاريخ",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font14whiteWeight600,
                  )),
              DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Center(
                        child: Text(
                      "اسم الدواء",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font14whiteWeight600,
                    )),
                  )),
              DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Center(
                      child: Text(
                        "مدة العلاج",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.font14whiteWeight600,
                      ),
                    ),
                  )),
              DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Center(
                      child: Text(
                    "امراض\n مزمنة",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font14whiteWeight600.copyWith(fontSize: 13.sp),
                  ))),
            ],
            rows: state.userMedicines.map((data) {
              return DataRow(cells: [
                DataCell(
                  Center(
                    child: Text(data.startDate,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                          style: AppTextStyles.font14whiteWeight600.copyWith(
                          color: AppColorsManager.mainDarkBlue,
                          decoration: TextDecoration.underline),),
                  ),
                   onTap: () async {
                   final sameDateMedicines= await context
                          .read<MedicineViewCubit>()
                          .getMedicinesByDate( data.startDate);
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return SameDateMedicineDetailsView(
                      medicines: sameDateMedicines,
                      date: data.startDate,
                    );
                  }));            
                }
                ),
                DataCell(
                    Center(
                      child: Text(
                        data.medicineName.split(' ').first,
                        style: AppTextStyles.font14whiteWeight600.copyWith(
                            color: AppColorsManager.mainDarkBlue,
                            decoration: TextDecoration.underline),
                        maxLines: 2,
                      ),
                    ), onTap: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return MedicineDetailsView(
                      documentId: data.id,
                    );
                  }));
                  if (context.mounted) {
                    await context
                        .read<MedicineViewCubit>()
                        .getUserMedicinesList();

                    await context
                        .read<MedicineViewCubit>()
                        .getMedicinesFilters();
                  }
                }),
                DataCell(Center(
                  child: Text(data.timeDuration,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font14whiteWeight600
                          .copyWith(color: AppColorsManager.textColor,fontSize: 12.sp)),
                )),
                DataCell(Center(
                  child: Text(
                    data.chronicDiseaseMedicine == 'لم يتم ادخال بيانات'
                        ? '-'
                        : data.chronicDiseaseMedicine,
                    style: AppTextStyles.font14whiteWeight600
                        .copyWith(color: AppColorsManager.textColor),
                    maxLines: 2,
                  ),
                )),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}