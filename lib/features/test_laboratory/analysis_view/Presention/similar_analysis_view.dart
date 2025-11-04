import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/loading_state_view.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
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
                    AppBarWithCenteredTitle(
                      title: 'التحاليل المماثلة',
                      showActionButtons: false,
                    ),
                    verticalSpacing(24),
                    CustomAnalysisContainer(
                        iconPath: 'assets/images/test_tube.png',
                        label: similarTestsResponse.testDetails.code,
                        title: similarTestsResponse.testDetails.nameTest,
                        description:
                            similarTestsResponse.testDetails.description),
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
                                similarTestsResponse
                                    .similarTests[index].testDate
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
                                  .similarTests[index].recommendation);
                        }),
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
