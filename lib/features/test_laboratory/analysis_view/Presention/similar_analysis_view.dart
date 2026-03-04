import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/appbar_with_centered_title_with_guidance.dart';
import 'package:we_care/core/global/SharedWidgets/loading_state_view.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/widgets/analysis_line_cart.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/widgets/custom_analysis_container.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/widgets/similar_analysis_card.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_cubit.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_state.dart';

class SimilarAnalysisView extends StatelessWidget {
  const SimilarAnalysisView({super.key, required this.testName});
  final String testName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TestAnalysisViewCubit>()
        ..emitGetSimilarTests(testName: testName),
      child: BlocBuilder<TestAnalysisViewCubit, TestAnalysisViewState>(
        buildWhen: (previous, current) =>
            previous.requestStatus != current.requestStatus &&
            current.isEditing == false,
        builder: (context, state) {
          if (state.requestStatus == RequestStatus.loading) {
            return LoadingStateView();
          }
          if (state.requestStatus == RequestStatus.failure) {
            return Scaffold(
              body: Center(
                child: Text(
                  state.message ?? 'حدث خطأ ما',
                  style: AppTextStyles.font14blackWeight400,
                ),
              ),
            );
          }
          final similarTestsResponse = state.getSimilarTestsResponseModel!.data;

          final isWrittenPercentTest = similarTestsResponse.similarTests
              .where((e) => e.writtenPercent != null)
              .toList();

// 2️⃣ لو مفيش قيم → متعملش chart خالص
          List<AnalysisData> dynamicChartData = [];

          if (isWrittenPercentTest.isNotEmpty) {
            dynamicChartData = isWrittenPercentTest
                .asMap()
                .entries
                .map(
                  (entry) => AnalysisData(
                    x: entry.key + 1,
                    y: entry.value.writtenPercent!.toDouble(),
                    label: entry.value.testDate,
                  ),
                )
                .toList();
          }

// نفس الـ standard rate
          String standardRateStr =
              similarTestsResponse.similarTests[0].standardRate;

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    CustomAppBarWithCenteredTitleWithGuidance(
                      title: 'التحاليل المماثلة',
                      trailingActions: [
                        CircleIconButton(
                          icon: Icons.play_arrow,
                          color:
                              state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                      true
                                  ? AppColorsManager.mainDarkBlue
                                  : Colors.grey,
                          onTap:
                              state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                      true
                                  ? () => launchYouTubeVideo(
                                      state.moduleGuidanceData!.videoLink)
                                  : null,
                        ),
                        SizedBox(width: 12.w),
                        CircleIconButton(
                          icon: Icons.menu_book_outlined,
                          color: state.moduleGuidanceData?.moduleGuidanceText
                                      ?.isNotEmpty ==
                                  true
                              ? AppColorsManager.mainDarkBlue
                              : Colors.grey,
                          onTap: state.moduleGuidanceData?.moduleGuidanceText
                                      ?.isNotEmpty ==
                                  true
                              ? () {
                                  ModuleGuidanceAlertDialog.show(
                                    context,
                                    title: "العمليات",
                                    description: state.moduleGuidanceData!
                                        .moduleGuidanceText!,
                                  );
                                }
                              : null,
                        ),
                      ],
                    ),
                    verticalSpacing(24),
                    CustomAnalysisContainer(
                      iconPath: 'assets/images/test_tube.png',
                      label: similarTestsResponse.testDetails.code,
                      title: similarTestsResponse.testDetails.nameTest,
                      description: similarTestsResponse.testDetails.description,
                    ),
                    verticalSpacing(16),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: similarTestsResponse.similarTests.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return SimilarAnalysisCard(
                            id: similarTestsResponse.similarTests[index].id,
                            testName: similarTestsResponse
                                .similarTests[index].testName,
                            date: [
                              similarTestsResponse.similarTests[index].testDate
                            ],
                            names: [
                              similarTestsResponse.similarTests[index].code
                            ],
                            ranges: [
                              similarTestsResponse
                                  .similarTests[index].standardRate
                            ],
                            results: [
                              similarTestsResponse
                                  .similarTests[index].writtenPercent
                                  .toString()
                            ],
                            interpretation: similarTestsResponse
                                .similarTests[index].interpretation,
                            recommendation: similarTestsResponse
                                .similarTests[index].recommendation,
                          );
                        }),
                    verticalSpacing(12),
                    if (dynamicChartData.isNotEmpty &&
                        dynamicChartData.isNotNull)
                      AnalysisLineChart(
                        data: dynamicChartData,
                        title: 'راقب نسب التغيرات',
                        normalMax: standardRateStr.maxValue ?? 400,
                        normalMin: standardRateStr.minValue ?? 0,
                      )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class InterpretationDetailsContainerWithTitleRow extends StatelessWidget {
  const InterpretationDetailsContainerWithTitleRow(
      {super.key, required this.content, required this.title});

  final String content;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // تفسير (التفسير) + أيقونة
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline,
              color: AppColorsManager.mainDarkBlue, size: 20),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
        ],
      ),

      verticalSpacing(8),

      // Interpretation Text
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent, // a slightly different background
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColorsManager.mainDarkBlue, width: 0.5),
        ),
        child: Text(
          content,
          style: AppTextStyles.font12blackWeight400,
          //textAlign: TextAlign.center,
        ),
      ),
    ]);
  }
}
