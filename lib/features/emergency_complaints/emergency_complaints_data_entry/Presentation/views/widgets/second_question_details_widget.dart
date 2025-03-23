import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/true_or_false_question_component.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaints_data_entry_cubit.dart';

class SecondQuestionDetails extends StatelessWidget {
  const SecondQuestionDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsDataEntryCubit,
        EmergencyComplaintsDataEntryState>(
      buildWhen: (previous, current) =>
          previous.isCurrentlyTakingMedication !=
          current.isCurrentlyTakingMedication,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrueOrFalseQuestionWidget(
              question: "هل تتناول أدوية حالية ؟",
              containerValidationColor:
                  state.isCurrentlyTakingMedication == null
                      ? AppColorsManager.redBackgroundValidationColor
                      : AppColorsManager.babyBlueColor,
              imagePath: "assets/images/medicines.png",
              onOptionSelected: (p0) {
                context
                    .read<EmergencyComplaintsDataEntryCubit>()
                    .updateIsTakingMedicines(p0);
              },
            ),
            // Animated container to show/hide the text fields
            showOrHideTextField(state, context),
          ],
        );
      },
    );
  }

  Widget showOrHideTextField(
      EmergencyComplaintsDataEntryState state, BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 500), // Animation duration
      curve: Curves.easeOutCirc,
      child: state.secondQuestionAnswer
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpacing(8),
                Text(
                  "اسم الدواء",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(8),
                CustomTextField(
                  controller: context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .medicineNameController,
                  validator: (value) {},
                  isPassword: false,
                  showSuffixIcon: false,
                  keyboardType: TextInputType.name,
                  hintText: "اكتب اسم الدواء",
                ),
                verticalSpacing(24),
                Text(
                  "الجرعة",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(8),
                CustomTextField(
                  controller: context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .medicineDoseController,
                  validator: (value) {},
                  isPassword: false,
                  showSuffixIcon: false,
                  keyboardType: TextInputType.name,
                  hintText: "اكتب الجرعة الموصى بها",
                ),
                verticalSpacing(24),
              ],
            )
          : SizedBox.shrink(),
    );
  }
}
