import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/true_or_false_question_component.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaints_data_entry_cubit.dart';

class ThirdQuestionDetails extends StatelessWidget {
  const ThirdQuestionDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsDataEntryCubit,
        EmergencyComplaintsDataEntryState>(
      buildWhen: (previous, current) =>
          previous.hasReceivedEmergencyCareBefore !=
              current.hasReceivedEmergencyCareBefore ||
          previous.thirdQuestionAnswer != current.thirdQuestionAnswer,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrueOrFalseQuestionWidget(
              initialOption: getInitialOption(
                thirdQuestionAnswer: state.thirdQuestionAnswer,
                isEditMode: state.isEditMode,
              ),
              question: "هل أجريت  تدخل طبى طارئ للشكوى ؟",
              containerValidationColor:
                  state.hasReceivedEmergencyCareBefore == null &&
                          state.thirdQuestionAnswer != true
                      ? AppColorsManager.redBackgroundValidationColor
                      : AppColorsManager.babyBlueColor,
              imagePath: "assets/images/medical_tool_kit.png",
              onOptionSelected: (p0) {
                context
                    .read<EmergencyComplaintsDataEntryCubit>()
                    .updateHasReceivedEmergencyCareBefore(p0);
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
      {required bool thirdQuestionAnswer, required bool isEditMode}) {
    if (isEditMode) {
      return thirdQuestionAnswer ? 'نعم' : 'لا';
    }
    return null;
  }

  Widget showOrHideTextField(
      EmergencyComplaintsDataEntryState state, BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 500), // Animation duration
      curve: Curves.easeOutCirc,
      child: state.thirdQuestionAnswer
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpacing(8),
                Text(
                  "نوع التدخل",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(8),
                CustomTextField(
                  controller: context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .emergencyInterventionTypeController,
                  validator: (value) {},
                  isPassword: false,
                  showSuffixIcon: false,
                  keyboardType: TextInputType.name,
                  hintText: "اكتب نوع التدخل",
                ),
                verticalSpacing(24),
                Text(
                  "التاريخ",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(8),
                DateTimePickerContainer(
                  placeholderText:
                      state.emergencyInterventionDate ?? "يوم / شهر / سنة",
                  onDateSelected: (pickedDate) {
                    context
                        .read<EmergencyComplaintsDataEntryCubit>()
                        .updateEmergencyInterventionDate(pickedDate);
                  },
                ),
                verticalSpacing(24),
              ],
            )
          : SizedBox.shrink(),
    );
  }
}
