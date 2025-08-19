import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/logic/cubit/mental_illnesses_data_entry_cubit.dart';

class SendButtonBlocConsumer extends StatelessWidget {
  final List<FcmQuestionModel> questions;
  final bool isAllQuestionsAnswered;

  const SendButtonBlocConsumer({
    super.key,
    required this.questions,
    required this.isAllQuestionsAnswered,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicalIllnessesDataEntryCubit,
        MedicalIllnessesDataEntryState>(
      listener: (context, state) async {
        if (state.questionareAnswersStatus == RequestStatus.success) {
          // ✅ Close the page when submission is successful

          await showSuccess(state.message);
          context.pop();
        }
      },
      builder: (context, state) {
        final RequestStatus status = state.questionareAnswersStatus;
        Widget child;

        switch (status) {
          case RequestStatus.loading:
            child = const SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColorsManager.mainDarkBlue,
              ),
            );
            break;

          case RequestStatus.success:
            child = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 24),
                horizontalSpacing(8),
                Text(
                  'تم الإرسال',
                  style: AppTextStyles.font20blackWeight600.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
              ],
            );
            break;

          case RequestStatus.failure:
            child = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 24),
                horizontalSpacing(8),
                Text(
                  'فشل الإرسال',
                  style: AppTextStyles.font20blackWeight600.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ],
            );
            break;

          case RequestStatus.initial:
            child = Text(
              'إرسال إجاباتي',
              style: AppTextStyles.font20blackWeight600.copyWith(
                fontWeight: FontWeight.w700,
                color: isAllQuestionsAnswered
                    ? AppColorsManager.mainDarkBlue
                    : Colors.grey,
              ),
            );
        }

        return Container(
          color: Colors.grey[50],
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: (!isAllQuestionsAnswered ||
                          status == RequestStatus.loading)
                      ? null
                      : () async {
                          await context
                              .read<MedicalIllnessesDataEntryCubit>()
                              .sendQuestionareAnswers(questions: questions);
                        },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                        color: isAllQuestionsAnswered
                            ? AppColorsManager.mainDarkBlue
                            : Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
