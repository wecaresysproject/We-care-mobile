import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaints_data_entry_cubit.dart';

import '../../../../../../core/global/SharedWidgets/user_selection_container_shared_widget.dart';

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

              /// size between each categogry
              verticalSpacing(16),

              UserSelectionContainer(
                containerBorderColor: state.doctorNameSelection == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "مكان الألم أو الشكوى",
                containerHintText:
                    state.doctorNameSelection ?? "اختر الأعراض المصاحبة",
                options: [
                  "غثيان",
                  "تعب المعده",
                  "تعب الصدر",
                  "تعب الجهاز النفسي",
                ],
                onOptionSelected: (value) {
                  log("xxx:Selected: $value");
                  context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateDoctorName(value);
                },
                bottomSheetTitle: "اختر الأعراض المصاحبة",
              ),

              verticalSpacing(16),
              UserSelectionContainer(
                containerBorderColor: state.doctorSpecialitySelection == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "الأعراض المرضية - المنطقة",
                containerHintText:
                    state.doctorSpecialitySelection ?? "اختر الأعراض المستدعية",
                options: [
                  "الجهاز النفسي",
                  "التعب النفسي",
                  "التعب الجهاز النفسي",
                ],
                onOptionSelected: (value) {
                  context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateDoctorSpeciality(value);

                  log("xxx:Selected: $value");
                },
                bottomSheetTitle: "اختر الأعراض المستدعية",
              ),

              verticalSpacing(16),

              UserSelectionContainer(
                allowManualEntry: true,
                categoryLabel:
                    "الأعراض المرضية - الشكوى", // Another Dropdown Example
                containerHintText:
                    "اختر الأعراض المستدعية", //state.selectedDisease ??
                options: [
                  "مرض القلب",
                  "مرض البول",
                  "مرض الدم",
                  "مرض القلب",
                ],
                onOptionSelected: (value) {
                  // context
                  //     .read<EmergencyComplaintsDataEntryCubit>()
                  //     .updateSelectedDisease(value);
                  log("xxx:Selected: $value");
                },
                bottomSheetTitle: "اختر الأعراض المستدعية",
              ),

              verticalSpacing(16),

              UserSelectionContainer(
                options: [],
                categoryLabel: "طبيعة الشكوى",
                bottomSheetTitle: "اختر طبيعة الشكوى",
                onOptionSelected: (value) async {
                  // context
                  //     .read<EmergencyComplaintsDataEntryCubit>()
                  //     .updateSelectedCityName(value);
                  // await context
                  //     .read<EmergencyComplaintsDataEntryCubit>()
                  //     .emitCitiesData();
                },
                containerHintText:
                    "اختر طبيعة الشكوى", //state.selectedCityName ?? "اختر المدينة",
              ),

              verticalSpacing(16),

              ///TODO: handle this button in main view and remove it from here
              /// final section
              verticalSpacing(32),
              submitPrescriptionDataEnteredBlocConsumer(),
              verticalSpacing(71),
            ],
          ),
        );
      },
    );
  }

  Widget submitPrescriptionDataEnteredBlocConsumer() {
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
