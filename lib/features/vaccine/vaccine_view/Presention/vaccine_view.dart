import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ViewAppBar(),
              FiltersRowBlocBuilder(),
              verticalSpacing(32),
              VaccinesTableBlocBuilder(),
              verticalSpacing(16),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: VaccineViewFooterRow(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VaccinesTableBlocBuilder extends StatelessWidget {
  const VaccinesTableBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaccineViewCubit, VaccineViewState>(
      buildWhen: (previous, current) =>
          previous.userVaccines != current.userVaccines ||
          previous.requestStatus != current.requestStatus ||
          previous.isDeleteRequest != current.isDeleteRequest,
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.userVaccines.isEmpty) {
          return Expanded(
            child: Center(
              child: Text('لا يوجد بيانات',
                  style: AppTextStyles.font22MainBlueWeight700),
            ),
          );
        }
        return Expanded(
          flex: 12,
          child: buildTable(context, state.userVaccines),
        );
      },
    );
  }
}

Widget buildTable(BuildContext context, List<UserVaccineModel> vaccinesData) {
  final ScrollController controller = ScrollController();
  return SingleChildScrollView(
    controller: controller,
    scrollDirection: Axis.vertical,
    child: DataTable(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      headingRowColor:
          WidgetStateProperty.all(Color(0xFF014C8A)), // Header Background Color
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
                "الترتيب",
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
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          )),
          DataCell(Center(
            child: Text(
              data.dose ?? "-",
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
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
            onTap: () async {
              final bool result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VaccineDetailsView(
                    documentId: data.id,
                  ),
                ),
              );
              if (result && context.mounted) {
                await context.read<VaccineViewCubit>().emitUserVaccinesData();
                if (!context.mounted) return;
                await context
                    .read<VaccineViewCubit>()
                    .emitFilteredVaccinesList();
              }
            },
          ),
        ]);
      }).toList(),
    ),
  );
}

class FiltersRowBlocBuilder extends StatelessWidget {
  const FiltersRowBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaccineViewCubit, VaccineViewState>(
      buildWhen: (previous, current) =>
          previous.yearsFilter != current.yearsFilter ||
          previous.vaccineTypesFilter != current.vaccineTypesFilter,
      builder: (context, state) {
        return DataViewFiltersRow(
          filters: [
            FilterConfig(
                title: 'السنة', options: state.yearsFilter, isYearFilter: true),
            FilterConfig(
                title: 'فئة اللقاح', options: state.vaccineTypesFilter),
          ],
          onApply: (selectedFilters) {
            AppLogger.debug("Selected Filters: $selectedFilters");
            BlocProvider.of<VaccineViewCubit>(context).emitFilteredVaccinesList(
                year: selectedFilters['السنة'].toString(),
                vaccineName: selectedFilters['فئة اللقاح']);
          },
        );
      },
    );
  }
}

class VaccineViewFooterRow extends StatelessWidget {
  const VaccineViewFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaccineViewCubit, VaccineViewState>(
      builder: (context, state) {
        final cubit = context.read<VaccineViewCubit>();
        return Column(
          children: [
            // Loading indicator that appears above the footer when loading more items
            if (state.isLoadingMore)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: LinearProgressIndicator(
                  minHeight: 2.h,
                  color: AppColorsManager.mainDarkBlue,
                  backgroundColor:
                      AppColorsManager.mainDarkBlue.withOpacity(0.1),
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Load More Button
                ElevatedButton(
                  onPressed: state.isLoadingMore || !cubit.hasMore
                      ? null
                      : () => cubit.loadMoreMedicines(),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(158.w, 32.h),
                    backgroundColor: state.isLoadingMore || !cubit.hasMore
                        ? Colors.grey
                        : AppColorsManager.mainDarkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: state.isLoadingMore
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            horizontalSpacing(8.w),
                            Text(
                              "جاري التحميل...",
                              style: AppTextStyles.font14whiteWeight600,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "عرض المزيد",
                              style:
                                  AppTextStyles.font14whiteWeight600.copyWith(
                                color: !cubit.hasMore
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            horizontalSpacing(8.w),
                            Icon(
                              Icons.expand_more,
                              color:
                                  !cubit.hasMore ? Colors.black : Colors.white,
                              size: 20.sp,
                            ),
                          ],
                        ),
                ),

                // Items Count Badge
                !cubit.hasMore
                    ? SizedBox.shrink()
                    : Container(
                        width: 47.w,
                        height: 28.h,
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11.r),
                          border: Border.all(
                            color: Color(0xFF014C8A),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "+${cubit.pageSize}",
                            style:
                                AppTextStyles.font16DarkGreyWeight400.copyWith(
                              color: AppColorsManager.mainDarkBlue,
                            ),
                          ),
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
