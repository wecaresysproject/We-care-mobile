import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/features/quality_of_life/logic/quality_of_life_cubit.dart';
import 'package:we_care/features/quality_of_life/logic/quality_of_life_state.dart';
import 'package:we_care/features/quality_of_life/presentation/widgets/quality_of_lify_module_note_widget.dart';

import '../widgets/quality_of_life_app_bar.dart';
import '../widgets/question_item_widget.dart';

class QualityOfLifeQuestionsView extends StatelessWidget {
  const QualityOfLifeQuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
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
              itemCount: QualityOfLifeCubit.questions.length,
              itemBuilder: (context, index) {
                final question = QualityOfLifeCubit.questions[index];
                return BlocBuilder<QualityOfLifeCubit, QualityOfLifeState>(
                  buildWhen: (previous, current) =>
                      previous.answers[question.id] !=
                      current.answers[question.id],
                  builder: (context, state) {
                    return QuestionItemWidget(
                      id: question.id,
                      question: question.question,
                      answers: question.answers,
                      selectedAnswer: state.answers[question.id],
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
            const SnackBar(
              content: Text('تم حفظ البيانات بنجاح'),
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
      buildWhen: (previous, current) => previous.isSaved != current.isSaved,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: AppCustomButton(
            title: "حفظ",
            onPressed: () {
              context.read<QualityOfLifeCubit>().saveAnswers();
            },
            isEnabled: true,
          ),
        );
      },
    );
  }
}
