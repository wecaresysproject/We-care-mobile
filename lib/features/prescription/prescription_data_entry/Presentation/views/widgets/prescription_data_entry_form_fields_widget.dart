import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/image_uploader_section_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/prescription/prescription_data_entry/logic/cubit/prescription_data_entry_cubit.dart';

import '../../../../../../core/global/SharedWidgets/user_selection_container_shared_widget.dart';

class PrescriptionDataEntryFormFields extends StatefulWidget {
  const PrescriptionDataEntryFormFields({super.key});

  @override
  State<PrescriptionDataEntryFormFields> createState() =>
      _PrescriptionDataEntryFormFieldsState();
}

class _PrescriptionDataEntryFormFieldsState
    extends State<PrescriptionDataEntryFormFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionDataEntryCubit, PrescriptionDataEntryState>(
      builder: (context, state) {
        return Form(
          key: context.read<PrescriptionDataEntryCubit>().formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تاريخ الروشتة",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              DateTimePickerContainer(
                containerBorderColor: state.preceriptionDateSelection == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                placeholderText:
                    state.preceriptionDateSelection ?? "يوم / شهر / سنة",
                onDateSelected: (pickedDate) {
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .updatePrescriptionDate(pickedDate);
                  log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
                },
              ),

              /// size between each categogry
              verticalSpacing(16),

              UserSelectionContainer(
                allowManualEntry: true,
                containerBorderColor: state.doctorNameSelection == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "اسم الطبيب",
                containerHintText:
                    state.doctorNameSelection ?? "اختر اسم الطبيب",
                options: state.doctorNames,
                onOptionSelected: (value) {
                  log("xxx:Selected: $value");
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .updateDoctorName(value);
                },
                bottomSheetTitle: "اختر اسم الطبيب",
                searchHintText: "ابحث عن اسم الطبيب",
              ),

              verticalSpacing(16),
              UserSelectionContainer(
                allowManualEntry: true,
                containerBorderColor: state.doctorSpecialitySelection == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "التخصص",
                containerHintText:
                    state.doctorSpecialitySelection ?? "اختر تخصص",
                options: state.doctorSpecialities,
                onOptionSelected: (value) {
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .updateDoctorSpeciality(value);

                  log("xxx:Selected: $value");
                },
                bottomSheetTitle: "اختر تخصص الطبيب",
                searchHintText: "ابحث عن التخصص",
              ),

              verticalSpacing(16),
              Text(
                "الأعراض المصاحبة للشكوى",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              WordLimitTextField(
                hintText: state.prescribtionEditedModel?.cause ??
                    "اكتب الأعراض التى تعانى منها",
                controller: context
                    .read<PrescriptionDataEntryCubit>()
                    .symptomsAccompanyingComplaintController,
              ),
              verticalSpacing(16),
              UserSelectionContainer(
                allowManualEntry: true,
                categoryLabel: "التشخيص", // Another Dropdown Example
                containerHintText:
                    state.selectedDisease ?? "اختر المرض الذى تم تشخيصه",
                options: state.diseasesNames,
                onOptionSelected: (value) {
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .updateSelectedDisease(value);
                  log("xxx:Selected: $value");
                },
                bottomSheetTitle: "اختر المرض الذى تم تشخيصه",
                searchHintText: "ابحث عن التشخيص المناسب",
              ),

              verticalSpacing(16),
              Text(
                "الروشتة (${state.prescriptionPictureUploadedUrl.length})",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              ImageUploaderSection<PrescriptionDataEntryCubit,
                  PrescriptionDataEntryState>(
                statusSelector: (state) => state.prescriptionImageRequestStatus,
                uploadedSelector: (state) =>
                    state.prescriptionPictureUploadedUrl,
                resultMessage: state.message,
                hasValidation: true,
                onRemove: (imagePath) {
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .removeUploadedImage(imagePath);
                },
                onUpload: (path) async {
                  await context
                      .read<PrescriptionDataEntryCubit>()
                      .uploadPrescriptionImagePicked(
                        imagePath: path,
                      );
                },
              ),

              verticalSpacing(16),

              ///الدولة
              UserSelectionContainer(
                options: state.countriesNames,
                categoryLabel: "الدولة",
                bottomSheetTitle: "اختر اسم الدولة",
                onOptionSelected: (value) async {
                  await context
                      .read<PrescriptionDataEntryCubit>()
                      .updateSelectedCountry(value);
                },
                containerHintText:
                    state.selectedCountryName ?? "اختر اسم الدولة",
                searchHintText: "ابحث عن الدولة",
              ),

              verticalSpacing(16),

              UserSelectionContainer(
                options: state.citiesNames,
                categoryLabel: "المدينة",
                bottomSheetTitle: "اختر المدينة",
                onOptionSelected: (value) async {
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .updateSelectedCityName(value);
                },
                containerHintText: state.selectedCityName ?? "اختر المدينة",
                searchHintText: "ابحث عن المدينة",
              ),

              verticalSpacing(16),

              Text(
                "ملاحظات شخصية",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              WordLimitTextField(
                controller: context
                    .read<PrescriptionDataEntryCubit>()
                    .personalNotesController,
                hintText: state.prescribtionEditedModel?.preDescriptionNotes ??
                    "اكتب باختصار اى معلومات مهمة اخرى",
              ),

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
    return BlocConsumer<PrescriptionDataEntryCubit, PrescriptionDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.preceriptionDataEntryStatus == RequestStatus.failure ||
          curr.preceriptionDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.preceriptionDataEntryStatus != curr.preceriptionDataEntryStatus,
      listener: (context, state) async {
        if (state.preceriptionDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          context.pop(result: true);
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.preceriptionDataEntryStatus == RequestStatus.loading,
          title: context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              state.isEditMode
                  ? await context
                      .read<PrescriptionDataEntryCubit>()
                      .submitEditsOnPrescription()
                  : await context
                      .read<PrescriptionDataEntryCubit>()
                      .postPrescriptionDataEntry(
                        context.translate,
                      );
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
