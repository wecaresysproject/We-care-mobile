import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/medicine_view/Presention/medicine_details_view.dart';
import 'package:we_care/features/medicine/medicine_view/Presention/similar_date_medicine_details_view.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_cubit.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_state.dart';
import 'package:we_care/features/prescription/Presentation_view/views/prescription_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class MedicinesView extends StatelessWidget {
  const MedicinesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicineViewCubit>(
      create: (context) => getIt<MedicineViewCubit>()
        ..getUserMedicinesList()
        ..getMedicinesFilters(),
      child: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<MedicineViewCubit>(context).getUserMedicinesList();
        },
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ViewAppBar(),
                BlocBuilder<MedicineViewCubit, MedicineViewState>(
                  buildWhen: (previous, current) =>
                      previous.yearsFilter != current.yearsFilter ||
                      previous.medicineNameFilter != current.medicineNameFilter,
                  builder: (context, state) {
                    return DataViewFiltersRow(
                      filters: [
                        FilterConfig(
                            title: 'السنة',
                            options: state.yearsFilter,
                            isYearFilter: true),
                        FilterConfig(
                            title: 'اسم الدواء', options:state.medicineNameFilter,isMedicineFilter: true),
                      ],
                      onApply: (selectedFilters) {
                        print("Selected Filters: $selectedFilters");
                        BlocProvider.of<MedicineViewCubit>(context)
                            .getFilteredMedicinesList(
                                year: selectedFilters['السنة'],
                                medicineName:
                                    selectedFilters['اسم الدواء'].toString());
                      },
                    );
                  },
                ),
                verticalSpacing(24),
                Text(
                  "“اضغط على اسم الدواء لعرض تفاصيله”",
                  style: AppTextStyles.customTextStyle,
                  textAlign: TextAlign.center,
                ),
                verticalSpacing(16),
                Expanded(flex: 9, child: MedicineTable()),
                verticalSpacing(16),
                XRayDataViewFooterRow(),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

            columnSpacing: 4.w,
            dataRowHeight: 60.h,
            horizontalMargin: 9,
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
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Center(
                        child: Text(
                      "امراض مزمنة",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font14whiteWeight600.copyWith(fontSize: 12.sp),
                    )),
                  )),
            ],
            rows: state.userMedicines.map((data) {
              return DataRow(cells: [
                DataCell(
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(data.startDate,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                            style: AppTextStyles.font14whiteWeight600.copyWith(
                            color: AppColorsManager.mainDarkBlue,
                            decoration: TextDecoration.underline),)
                    ),
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
                  child: FittedBox(
                    child: Text(data.timeDuration,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font14whiteWeight600
                            .copyWith(color: AppColorsManager.textColor)),
                  ),
                )),
                DataCell(Center(
                  child: Text(
                    data.chronicDiseaseMedicine == 'لم يتم ادخال بيانات'
                        ? '-'
                        : data.chronicDiseaseMedicine,
                    style: AppTextStyles.font14whiteWeight600
                        .copyWith(color: AppColorsManager.textColor),
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

class CustomAppContainer extends StatelessWidget {
  const CustomAppContainer({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColorsManager.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.font12blackWeight400
                .copyWith(fontWeight: FontWeight.w500),
          ),
          horizontalSpacing(8),
          Text(
            value.toString(),
            style: AppTextStyles.font16DarkGreyWeight400
                .copyWith(color: AppColorsManager.mainDarkBlue),
          ),
        ],
      ),
    );
  }
}
