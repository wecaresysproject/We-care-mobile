import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.error ?? 'حدث خطأ ما'),
                  ],
                ),
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
