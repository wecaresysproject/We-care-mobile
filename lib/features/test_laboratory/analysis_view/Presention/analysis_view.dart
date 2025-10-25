import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/empty_state_widget.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/SharedWidgets/loading_state_view.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/analysis_details_view.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/similar_analysis_view.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/widgets/analysis_view_footer_row.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/widgets/custom_app_container.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_cubit.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_state.dart';
import 'package:we_care/features/test_laboratory/data/models/get_user_analysis_response_model.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/search_filter_widget.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class MedicalAnalysisView extends StatelessWidget {
  const MedicalAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TestAnalysisViewCubit>(
      create: (context) => getIt<TestAnalysisViewCubit>()..init(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<TestAnalysisViewCubit, TestAnalysisViewState>(
              builder: (context, state) {
                return Column(
                  children: [
                    ViewAppBar(),
                    
                    _buildFilterAndCountSection(context, state),
                    
                    verticalSpacing(8),
                    
                  state.analysisSummarizedDataList.isNotEmpty?  Text(
                      "اضغط على التاريخ لعرض التحليل\nاضغط على النتيجة لعرض تحاليك المماثلة",
                      style: AppTextStyles.customTextStyle,
                      textAlign: TextAlign.center,
                    ):SizedBox.shrink(),      
                    verticalSpacing(16),
                    Expanded(
                      flex: 12,
                      child: _buildMainContent(context, state),
                    ),
                                        if (state.requestStatus != RequestStatus.loading && state.requestStatus != RequestStatus.failure && state.analysisSummarizedDataList.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: AnalysisViewFooterRow(),
                      ),
                    
                    Spacer(flex: 1),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterAndCountSection(BuildContext context, TestAnalysisViewState state) {
    if (state.requestStatus == RequestStatus.loading || state.requestStatus == RequestStatus.failure) {
      return SizedBox.shrink();
    }
    
    return Row(
      children: [
        SearchFilterWidget(
          filterTitle: 'السنة',
          isYearFilter: true,
          filterList: state.yearsFilter,
          onFilterSelected: (filterTitle, selectedValue) {
            if (selectedValue == 0 || selectedValue == null) {
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
    );
  }

  Widget _buildMainContent(BuildContext context, TestAnalysisViewState state) {
    // Initial loading state
    if (state.requestStatus == RequestStatus.loading) {
      return LoadingStateView();
    }
    
    if (state.requestStatus == RequestStatus.failure) {
      return ErrorViewWidget(
        errorMessage: state.message ?? "حدث خطأ غير متوقع",
        onRetry: () => context.read<TestAnalysisViewCubit>().init(),
      );
    }
    
    if (state.analysisSummarizedDataList.isEmpty) {
      return EmptyStateWidget(
        message: "لا توجد تحاليل متاحة",
        imagePath: "assets/images/medical_file_icon.png", 
        buttonText: "تحديث",
        onButtonPressed: () => context.read<TestAnalysisViewCubit>().init(),
      );
    }
    
    return buildAnalysisTable(context, state.analysisSummarizedDataList);
  }

  Widget buildAnalysisTable(BuildContext context,
      List<AnalysisSummarizedData> analysisSummarizedData) {
    final ScrollController controller = ScrollController();
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.vertical,
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: MaterialStateProperty.all(
            Color(0xFF014C8A)), // Header Background Color
        headingTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold), // Header Text
        columnSpacing: 9.5.w,
        dataRowHeight: 70.h,
        horizontalMargin: 6.w,
        showBottomBorder: true,
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(16.r),
          color: Color(0xff909090),
          width: .3,
        ),
        columns: [
          _buildDataColumn("التاريخ"),
          _buildDataColumn("الاسم"),
          _buildDataColumn("الرمز"),
          _buildDataColumn("المعيار"),
          _buildDataColumn("النتيجة"),
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
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
              onTap: () => _navigateToDetailsView(context, data),
            ),
            _buildDataCellCenter(data.testName, maxLines: 3),
            _buildDataCellCenter(data.code),
            _buildDataCellCenter(data.standardRate ?? '-', color: Colors.black),
            DataCell(
              Center(
                child: Text(data.result.toString(),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColorsManager.mainDarkBlue,
                        decoration: TextDecoration.underline,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600)),
              ),
              onTap: () => _navigateToSimilarAnalysisView(context, data),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  DataColumn _buildDataColumn(String title) {
    return DataColumn(
      headingRowAlignment: MainAxisAlignment.center,
      label: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16.sp),
        ),
      ),
    );
  }

  DataCell _buildDataCellCenter(String text, {int maxLines = 3, Color? color}) {
    return DataCell(
      Center(
        child: Text(
          text,
          maxLines: maxLines,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color ?? Colors.black87,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToDetailsView(BuildContext context, AnalysisSummarizedData data) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AnalysisDetailsView(
          documentId: data.id,
          testName: data.testName,
        ),
      ),
    );
    
    if (result == true && context.mounted) {
      await context.read<TestAnalysisViewCubit>().emitTests();
    }
  }

  Future<void> _navigateToSimilarAnalysisView(BuildContext context, AnalysisSummarizedData data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SimilarAnalysisView(
          testName: data.testName,
        ),
      ),
    );

    if (context.mounted) {
      await context.read<TestAnalysisViewCubit>().emitTests();
    }
  }
}
