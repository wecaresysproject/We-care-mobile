import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/surgeries/surgeries_view/views/surgeries_view.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';
import 'package:we_care/features/vaccine/vaccine_view/Presention/vaccine_details_view.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccine_view_cubit.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccne_view_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class VaccineView extends StatelessWidget {
  const VaccineView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VaccineViewCubit>(
      create: (context) => getIt<VaccineViewCubit>()
        ..emitUserVaccinesData()
        ..emitVaccinesFilters(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: BlocBuilder<VaccineViewCubit, VaccineViewState>(
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ViewAppBar(),
                  DataViewFiltersRow(
                    filters: [
                      FilterConfig(
                          title: 'السنة',
                          options: state.yearsFilter,
                          isYearFilter: true),
                      FilterConfig(
                          title: 'فئة اللقاح',
                          options: state.vaccineTypesFilter),
                    ],
                    onApply: (selectedFilters) {},
                  ),
                  verticalSpacing(32),
                  Expanded(
                    flex: 12,
                    child: buildTable(context, state.userVaccines),
                  ),
                  verticalSpacing(16),
                  XRayDataViewFooterRow(),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildTable(BuildContext context, List<UserVaccineModel> vaccinesData) {
    final ScrollController controller = ScrollController();
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.vertical,
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: WidgetStateProperty.all(
            Color(0xFF014C8A)), // Header Background Color
        headingTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold), // Header Text
        columnSpacing: 22.w,
        dataRowHeight: 70.h,
        horizontalMargin: 10.w,
        showBottomBorder: true,
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(16.r),
          color: Color(0xff909090),
          width: .3,
        ),
        columns: [
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Center(
                  child: Text(
                "التاريخ",
                textAlign: TextAlign.center,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.sp),
              ))),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Center(
                  child: Text(
                "الاسم",
                textAlign: TextAlign.center,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.sp),
              ))),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Center(
                child: Text(
                  "المرض",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16.sp),
                ),
              )),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Center(
                  child: Text(
                "التفاصيل",
                textAlign: TextAlign.center,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.sp),
              ))),
        ],
        rows: vaccinesData.map((data) {
          return DataRow(cells: [
            DataCell(
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(data.vaccineDate,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ),
            ),
            DataCell(Center(
              child: Text(
                data.vaccineName,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )),
            DataCell(Center(
              child: Text(
                data.diseases,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
            DataCell(
              Center(
                  child: Container(
                width: 58.w,
                height: 40.h,
                padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
                decoration: BoxDecoration(
                  color: AppColorsManager.mainDarkBlue,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'عرض',
                      style: AppTextStyles.font22WhiteWeight600
                          .copyWith(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    horizontalSpacing(4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                ),
              )),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VaccineDetailsView()),
                );
              },
            ),
          ]);
        }).toList(),
      ),
    );
  }
}
