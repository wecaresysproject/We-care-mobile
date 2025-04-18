import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/surgeries/surgeries_view/views/surgeries_view.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/analysis_details_view.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/similar_analysis_view.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_cubit.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_state.dart';
import 'package:we_care/features/test_laboratory/data/models/get_user_analysis_response_model.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/search_filter_widget.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class MedicalAnalysisView extends StatelessWidget {
 

 const MedicalAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TestAnalysisViewCubit>(
      create: (context) => getIt<TestAnalysisViewCubit>()
        ..emitFilters()
        ..emitTests(),
      child: BlocBuilder<TestAnalysisViewCubit, TestAnalysisViewState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ViewAppBar(),
                  Row(
                    children: [
                      SearchFilterWidget(
                        filterTitle: 'السنة',
                        isYearFilter: true,
                        filterList: state.yearsFilter,
                        onFilterSelected: (filterTitle, selectedValue) {
                          if(selectedValue == 0) {
                            context.read<TestAnalysisViewCubit>().emitTests();
                            return;
                          }
                          if (selectedValue == null) {
                            context.read<TestAnalysisViewCubit>().emitTests();
                            return;
                          } else {
                            context
                                .read<TestAnalysisViewCubit>()
                                .emitFilteredData(selectedValue);
                          }
                        },
                      ),
                      Spacer(),
                      CustomAppContainer(
                          label: 'العدد',
                          value: state.analysisSummarizedDataList.length),
                    ],
                  ),
                  verticalSpacing(8),
                  Text(
                    "اضغط على التاريخ لعرض التحليل\nاضغط على النتيجة لعرض تحاليك المماثلة",
                    style: AppTextStyles.customTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  verticalSpacing(16),
                  Expanded(
                    flex: 12,
                    child:
                        buildTable(context, state.analysisSummarizedDataList),
                  ),
                  verticalSpacing(16),
                  XRayDataViewFooterRow(),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTable(BuildContext context,
      List<AnalysisSummarizedData> analysisSummarizedData) {
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
        columnSpacing: 9.5.w,
        dataRowHeight: 70.h,
        horizontalMargin: 10,
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
                  "الرمز",
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
                "المعيار",
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
                "النتيجة",
                textAlign: TextAlign.center,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.sp),
              ))),
        ],
        rows: analysisSummarizedData.map((data) {
          return DataRow(cells: [
            DataCell(
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(data.testDate,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColorsManager.mainDarkBlue,
                        decoration: TextDecoration.underline,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
              onTap: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnalysisDetailsView(
                      documentId: data.id,
                    ),
                  ),
                );
                if (result != null as bool? && context.mounted) {
                  await context.read<TestAnalysisViewCubit>().emitTests();
                }
              },
            ),
            DataCell(Center(
              child: Text(
                data.testName,
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
                data.code,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
            DataCell(Center(
              child: Text(
                data.standardRate ?? '-',
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
            DataCell(
              onTap: () async {
                bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SimilarAnalysisView(
                      testName: data.testName,
                    ),
                  ),
                );

                if (result && context.mounted) {
                  await context.read<TestAnalysisViewCubit>().emitTests();
                }
              },
              Center(
                child: Text(data.result.toString(),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColorsManager.mainDarkBlue,
                        decoration: TextDecoration.underline,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ]);
        }).toList(),
      ),
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
