import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/true_or_false_question_component.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaints_data_entry_cubit.dart';

class FirstQuestionDetails extends StatelessWidget {
  const FirstQuestionDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsDataEntryCubit,
        EmergencyComplaintsDataEntryState>(
      buildWhen: (previous, current) =>
          previous.hasSimilarComplaintBefore !=
              current.hasSimilarComplaintBefore ||
          previous.firstQuestionAnswer != current.firstQuestionAnswer,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrueOrFalseWithQuestionWidget(
              initialOption: getInitialOption(
                firstQuestionAnswer: state.firstQuestionAnswer,
                isEditMode: state.isEditMode,
              ),
              question: "هل عانيت من شكوى مشابهة سابقًا ؟",
              containerValidationColor:
                  state.hasSimilarComplaintBefore == null &&
                          state.firstQuestionAnswer != true
                      ? AppColorsManager.redBackgroundValidationColor
                      : AppColorsManager.babyBlueColor,
              imagePath: "assets/images/sick_outline_imoji.png",
              onOptionSelected: (p0) {
                context
                    .read<EmergencyComplaintsDataEntryCubit>()
                    .updateHasPreviousComplaintBefore(p0);
              },
            ),
            // Animated container to show/hide the text fields
            showOrHideTextField(state, context),
          ],
        );
      },
    );
  }

  String? getInitialOption(
      {required bool firstQuestionAnswer, required bool isEditMode}) {
    if (isEditMode) {
      return firstQuestionAnswer ? 'نعم' : 'لا';
    }
    return null;
  }

  AnimatedSize showOrHideTextField(
      EmergencyComplaintsDataEntryState state, BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 500), // Animation duration
      curve: Curves.easeOutCirc,
      child: state.firstQuestionAnswer
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpacing(8),
                Text(
                  "التشخيص",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(8),
                CustomTextField(
                  controller: context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .complaintDiagnosisController,
                  validator: (value) {},
                  isPassword: false,
                  showSuffixIcon: false,
                  keyboardType: TextInputType.name,
                  hintText: "اكتب التشخيص الذى تم",
                ),
                verticalSpacing(24),
                UserSelectionContainer(
                  options: [
                    "من يوم",
                    "من ايام",
                    "من اسبوع",
                    "من اسابيع",
                    "من شهر",
                    "من اشهر قليلة",
                    "من عدة اشهر",
                    "من سنة",
                    "من سنوات قليلة",
                    "من عدة سنوات",
                  ],
                  categoryLabel: "تاريخ الشكوى",
                  bottomSheetTitle: "اختر تاريخ الشكوى",
                  onOptionSelected: (value) {
                    context
                        .read<EmergencyComplaintsDataEntryCubit>()
                        .updateIfHasSameComplaintBeforeDate(value);
                  },
                  searchHintText: "ابحث عن تاريخ الشكوى",
                  containerHintText:
                      state.previousComplaintDate ?? "اختر تاريخ الشكوى",
                )
              ],
            )
          : const SizedBox.shrink(), // Hide when false
    );
  }
}
