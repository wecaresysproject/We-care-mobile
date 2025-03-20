import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_data_entry/Presentation/views/widgets/first_question_details_widget.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_data_entry/Presentation/views/widgets/second_question_details_widget.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_data_entry/Presentation/views/widgets/thirst_question_details_widget.dart';

import '../../../logic/cubit/emergency_complaints_data_entry_cubit.dart';

class EmergencyComplaintDataEntryFormFields extends StatefulWidget {
  const EmergencyComplaintDataEntryFormFields({super.key});

  @override
  State<EmergencyComplaintDataEntryFormFields> createState() =>
      _EmergencyComplaintDataEntryFormFieldsState();
}

class _EmergencyComplaintDataEntryFormFieldsState
    extends State<EmergencyComplaintDataEntryFormFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsDataEntryCubit,
        EmergencyComplaintsDataEntryState>(
      builder: (context, state) {
        return Form(
          key: context.read<EmergencyComplaintsDataEntryCubit>().formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تاريخ ظهور الشكوى",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              DateTimePickerContainer(
                containerBorderColor: state.complaintAppearanceDate == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                placeholderText:
                    state.complaintAppearanceDate ?? "يوم / شهر / سنة",
                onDateSelected: (pickedDate) {
                  context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateDateOfComplaint(pickedDate);
                  log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
                },
              ),

              state.isNewComplaintAddedSuccefully
                  ? Text(
                      "تم اضافة شكوى جديدة",
                      style: AppTextStyles.font18blackWight500,
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),

              /// size between each categogry
              verticalSpacing(16),
              Center(
                child: AddNewMedicalComplaintButton(
                  text: 'أضف أعراض مرضية أخرى ان وجد',
                  onPressed: () async {
                    await context.pushNamed(Routes.addNewComplaintDetails);
                  },
                ),
              ),

              verticalSpacing(16),
              FirstQuestionDetails(),
              verticalSpacing(16),

              SecondQuestionDetails(),
              verticalSpacing(16),
              ThirdQuestionDetails(),
              verticalSpacing(16),

              Text(
                "ملاحظات شخصية",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              WordLimitTextField(
                controller: context
                    .read<EmergencyComplaintsDataEntryCubit>()
                    .personalInfoController,
                hintText: "اكتب باختصار اى معلومات مهمة اخرى",

                // hintText: state.prescribtionEditedModel?.preDescriptionNotes ??
                //     "اكتب باختصار اى معلومات مهمة اخرى",
              ),

              ///TODO: handle this button in main view and remove it from here
              /// final section
              verticalSpacing(32),
              submitEmergencyDataEnteredBlocConsumer(),
              verticalSpacing(71),
            ],
          ),
        );
      },
    );
  }

  Widget submitEmergencyDataEnteredBlocConsumer() {
    return BlocConsumer<EmergencyComplaintsDataEntryCubit,
        EmergencyComplaintsDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.emergencyComplaintsDataEntryStatus == RequestStatus.failure ||
          curr.emergencyComplaintsDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.emergencyComplaintsDataEntryStatus !=
              curr.emergencyComplaintsDataEntryStatus,
      listener: (context, state) async {
        if (state.emergencyComplaintsDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          context.pop(result: true);
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading:
              state.emergencyComplaintsDataEntryStatus == RequestStatus.loading,
          title: context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              // state.isEditMode
              //     ? await context
              //         .read<EmergencyComplaintsDataEntryCubit>()
              //         .submitEditsOnPrescription()
              //     : await context
              //         .read<EmergencyComplaintsDataEntryCubit>()
              //         .postPrescriptionDataEntry(
              //           context.translate,
              //         );
              log("xxx:Save Data Entry");
            } else {
              log("form not validated");
            }
          },
          isEnabled: state.isFormValidated ? true : false,
        );
      },
    );
  }
}

class AddNewMedicalComplaintButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AddNewMedicalComplaintButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 4, horizontal: 16), // Padding from Figma
      decoration: BoxDecoration(
        color: const Color(0xFF014C8A), // Main color from Figma
        borderRadius: BorderRadius.circular(12), // Radius from Figma
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, color: Colors.white, size: 20), // "+" Icon
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl, // Arabic text support
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Ensures proper spacing inside Container
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
