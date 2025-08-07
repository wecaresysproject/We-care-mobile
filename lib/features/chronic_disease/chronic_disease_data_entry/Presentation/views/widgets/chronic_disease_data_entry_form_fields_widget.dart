import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:we_care/core/Database/dummy_data.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/add_new_item_button_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/options_selector_shared_container_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_data_entry/logic/cubit/chronic_disease_data_entry_cubit.dart';

import '../../../../../../core/global/SharedWidgets/user_selection_container_shared_widget.dart';

class ChronicDiseaseDataEntryFormFields extends StatefulWidget {
  const ChronicDiseaseDataEntryFormFields({super.key});

  @override
  State<ChronicDiseaseDataEntryFormFields> createState() =>
      _ChronicDiseaseDataEntryFormFieldsState();
}

class _ChronicDiseaseDataEntryFormFieldsState
    extends State<ChronicDiseaseDataEntryFormFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChronicDiseaseDataEntryCubit,
        ChronicDiseaseDataEntryState>(
      builder: (context, state) {
        return Form(
          key: context.read<ChronicDiseaseDataEntryCubit>().formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تاريخ بداية التشخيص",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              DateTimePickerContainer(
                containerBorderColor: state.diagnosisStartDate == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                placeholderText: state.diagnosisStartDate ?? "يوم / شهر / سنة",
                onDateSelected: (pickedDate) {
                  context
                      .read<ChronicDiseaseDataEntryCubit>()
                      .updateDiagnosisStartDate(pickedDate);
                  log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
                },
              ),

              /// size between each categogry
              verticalSpacing(16),
              UserSelectionContainer(
                allowManualEntry: true,
                containerBorderColor: state.chronicDiseaseName == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "المرض المزمن",
                containerHintText:
                    state.chronicDiseaseName ?? "اختر المرض المزمن",
                options: medicalSpecialties,
                onOptionSelected: (value) {
                  context
                      .read<ChronicDiseaseDataEntryCubit>()
                      .updateChronicDisease(value);
                },
                bottomSheetTitle: "اختر المرض المزمن",
                searchHintText: "ابحث عن المرض المزمن",
              ),
              verticalSpacing(16),

              buildAddNewMedicationButtonBlocBuilder(context),
              verticalSpacing(16),
              UserSelectionContainer(
                allowManualEntry: true,
                categoryLabel: 'الطبيب المتابع',
                containerHintText:
                    state.doctorNameSelection ?? "اختر اسم الطبيب المتابع",
                options: doctorsList,
                onOptionSelected: (value) {
                  log("xxx:Selected: $value");
                  context
                      .read<ChronicDiseaseDataEntryCubit>()
                      .updateDoctorName(value);
                },
                bottomSheetTitle: " اختر اسم الطبيب المتابع",
                searchHintText: "ابحث عن اسم الطبيب المتابع",
              ),

              verticalSpacing(16),

              Text(
                "حالة المرض",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              OptionSelectorWidget(
                containerValidationColor: state.diseaseStatus == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                options: [
                  'متدهور',
                  'متذبذب',
                  'تحت السيطرة',
                  'مستقر',
                ],
                initialSelectedOption: state.diseaseStatus,
                onOptionSelected: (p0) {
                  context
                      .read<ChronicDiseaseDataEntryCubit>()
                      .updateDiseaseStatus(p0);
                },
              ),
              verticalSpacing(16),
              Text(
                "الأعراض الجانبية",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              CustomTextField(
                controller: context
                    .read<ChronicDiseaseDataEntryCubit>()
                    .sideEffectsController,
                hintText: 'اكتب الأعراض الجانبية',
                validator: (val) {},
              ),
              verticalSpacing(10),

              Text(
                "ملاحظات شخصية",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              WordLimitTextField(
                controller: context
                    .read<ChronicDiseaseDataEntryCubit>()
                    .personalNotesController,
                hintText: state.prescribtionEditedModel?.preDescriptionNotes ??
                    "اكتب باختصار اى معلومات مهمة اخرى",
              ),

              ///TODO: handle this button in main view and remove it from here
              /// final section
              verticalSpacing(32),
              submitChronicDiseaseDataEnteredBlocConsumer(),
              verticalSpacing(71),
            ],
          ),
        );
      },
    );
  }

  Widget buildAddNewMedicationButtonBlocBuilder(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AddNewItemButton(
            text: // state.medicalComplaints.isEmpty
                // ? "اضف الاعراض المرضية"
                //:
                'أضف دواء جديد',
            onPressed: () async {
              final bool? result = await context.pushNamed(
                Routes.addNewMedicationView,
              );

              // if (result != null && context.mounted) {
              //   await context
              //       .read<EmergencyComplaintsDataEntryCubit>()
              //       .fetchAllAddedComplaints();

              //   if (!context.mounted) return;

              //   ///to rebuild submitted button if user added new complain.
              //   context
              //       .read<EmergencyComplaintsDataEntryCubit>()
              //       .validateRequiredFields();
              // }
            },
          ),
          Positioned(
            top: -2, // move it up (negative means up)
            left: -120,
            child: Lottie.asset(
              'assets/images/hand_animation.json',
              width: 120, // adjust sizes
              height: 120,
              addRepaintBoundary: true,
              repeat: true,
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget submitChronicDiseaseDataEnteredBlocConsumer() {
    return BlocConsumer<ChronicDiseaseDataEntryCubit,
        ChronicDiseaseDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.chronicDiseaseDataEntryStatus == RequestStatus.failure ||
          curr.chronicDiseaseDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.chronicDiseaseDataEntryStatus !=
              curr.chronicDiseaseDataEntryStatus,
      listener: (context, state) async {
        if (state.chronicDiseaseDataEntryStatus == RequestStatus.success) {
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
              state.chronicDiseaseDataEntryStatus == RequestStatus.loading,
          title: context.translate.send,
          onPressed: () async {
            // if (state.isFormValidated) {
            //   state.isEditMode
            //       ? await context
            //           .read<ChronicDiseaseDataEntryCubit>()
            //           .submitEditsOnPrescription()
            //       : await context
            //           .read<ChronicDiseaseDataEntryCubit>()
            //           .postPrescriptionDataEntry(
            //             context.translate,
            //           );
            //   log("xxx:Save Data Entry");
            // } else {
            //   log("form not validated");
            // }
          },
          isEnabled: state.isFormValidated ? true : false,
        );
      },
    );
  }
}
