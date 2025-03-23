import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/true_or_false_question_component.dart';
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
          current.hasSimilarComplaintBefore,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrueOrFalseQuestionWidget(
              question: "هل عانيت من شكوى مشابهة سابقًا ؟",
              containerValidationColor: state.hasSimilarComplaintBefore == null
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
                Text(
                  "تاريخ الشكوى",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(8),
                DateTimePickerContainer(
                  placeholderText: "يوم / شهر / سنة",
                  onDateSelected: (pickedDate) {
                    context
                        .read<EmergencyComplaintsDataEntryCubit>()
                        .updateIfHasSameComplaintBeforeDate(pickedDate);
                  },
                ),
              ],
            )
          : const SizedBox.shrink(), // Hide when false
    );
  }
}
