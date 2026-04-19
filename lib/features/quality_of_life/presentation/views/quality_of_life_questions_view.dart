import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/quality_of_life/logic/quality_of_life_cubit.dart';
import 'package:we_care/features/quality_of_life/logic/quality_of_life_state.dart';
import 'package:we_care/features/quality_of_life/presentation/widgets/quality_of_lify_module_note_widget.dart';

import '../widgets/quality_of_life_app_bar.dart';
import '../widgets/question_item_widget.dart';

class QualityOfLifeQuestionsView extends StatefulWidget {
  const QualityOfLifeQuestionsView({super.key});

  @override
  State<QualityOfLifeQuestionsView> createState() =>
      _QualityOfLifeQuestionsViewState();
}

class _QualityOfLifeQuestionsViewState
    extends State<QualityOfLifeQuestionsView> {
  @override
  void initState() {
    super.initState();
    context.read<QualityOfLifeCubit>().fetchQuestionnaire();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocBuilder<QualityOfLifeCubit, QualityOfLifeState>(
        builder: (context, state) {
          switch (state.questionnaireStatus) {
            case RequestStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case RequestStatus.failure:
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const QualityOfLifeAppBar(),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30.w),
                        padding: EdgeInsets.symmetric(
                          vertical: 32.h,
                          horizontal: 24.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColorsManager.mainDarkBlue
                                  .withOpacity(0.08),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: AppColorsManager
                                    .redBackgroundValidationColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.error_outline_rounded,
                                color: AppColorsManager.warningColor,
                                size: 50.sp,
                              ),
                            ),
                            verticalSpacing(24),
                            Text(
                              "حدث خطأ ما",
                              style: AppTextStyles.font20blackWeight600,
                            ),
                            verticalSpacing(12),
                            Text(
                              state.error ??
                                  'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.',
                              textAlign: TextAlign.center,
                              style:
                                  AppTextStyles.font14blackWeight400.copyWith(
                                color: AppColorsManager.placeHolderColor,
                                height: 1.5,
                              ),
                            ),
                            verticalSpacing(32),
                            AppCustomButton(
                              title: 'إعادة المحاولة',
                              isEnabled: true,
                              textFontSize: 18,
                              onPressed: () {
                                context
                                    .read<QualityOfLifeCubit>()
                                    .fetchQuestionnaire();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            case RequestStatus.success:
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const QualityOfLifeAppBar(),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16.w),
                      itemCount: state.questions.length,
                      itemBuilder: (context, index) {
                        final question = state.questions[index];
                        return BlocBuilder<QualityOfLifeCubit,
                            QualityOfLifeState>(
                          buildWhen: (previous, current) =>
                              previous.answers[question.questionId] !=
                              current.answers[question.questionId],
                          builder: (context, state) {
                            return QuestionItemWidget(
                              id: question.questionId,
                              question: question.questionText,
                              answers: question.options
                                  .map((e) => e.optionText)
                                  .toList(),
                              selectedAnswer:
                                  state.answers[question.questionId],
                              onAnswerSelected: (id, answer) {
                                context
                                    .read<QualityOfLifeCubit>()
                                    .selectAnswer(id, answer);
                              },
                            );
                          },
                        );
                      },
                    ),
                    verticalSpacing(16),
                    const QualityOfLifeModuleNote(),
                    const QualityOfLifeSaveButton(),
                  ],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class QualityOfLifeSaveButton extends StatelessWidget {
  const QualityOfLifeSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QualityOfLifeCubit, QualityOfLifeState>(
      listenWhen: (previous, current) =>
          previous.isSaved != current.isSaved ||
          previous.error != current.error,
      listener: (context, state) {
        if (state.isSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'تم حفظ البيانات بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }

        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      buildWhen: (previous, current) =>
          previous.isSaved != current.isSaved ||
          previous.submitStatus != current.submitStatus,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: AppCustomButton(
            title: "حفظ",
            onPressed: () {
              context.read<QualityOfLifeCubit>().submitAssessment();
            },
            isLoading: state.submitStatus == RequestStatus.loading,
            isEnabled: true,
          ),
        );
      },
    );
  }
}
