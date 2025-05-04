import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/logic/cubit/vaccine_data_entry_cubit.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/logic/cubit/vaccine_data_entry_state.dart';
import 'package:we_care/generated/l10n.dart';

import '../../../../../../core/global/SharedWidgets/user_selection_container_shared_widget.dart';

class VaccineDataEntryFormFields extends StatefulWidget {
  const VaccineDataEntryFormFields({super.key});

  @override
  State<VaccineDataEntryFormFields> createState() =>
      _VaccineDataEntryFormFieldsState();
}

class _VaccineDataEntryFormFieldsState
    extends State<VaccineDataEntryFormFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaccineDataEntryCubit, VaccineDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ التطعيم",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              containerBorderColor: state.vaccineDateSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText: state.vaccineDateSelection ?? "يوم / شهر / سنة",
              onDateSelected: (pickedDate) {
                context
                    .read<VaccineDataEntryCubit>()
                    .updateVaccineDate(pickedDate);
                log("xxx: pickedDate: $pickedDate");
              },
            ),

            /// size between each categogry
            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.selectedVaccineCategory == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "فئة اللقاح",
              containerHintText:
                  state.selectedVaccineCategory ?? "اختر فئة اللقاح",
              options: state.vaccineCategories,
              onOptionSelected: (value) {
                context
                    .read<VaccineDataEntryCubit>()
                    .updateSelectedVaccineCategory(value);
              },
              bottomSheetTitle: "اختر فئة اللقاح",
              searchHintText: "ابحث عن فئة اللقاح",
            ),
            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.selectedVaccineName == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "اسم الطعم",
              containerHintText: state.selectedVaccineName ?? "اختر اسم الطعم",
              options: state.vaccinesNames,
              onOptionSelected: (value) {
                context.read<VaccineDataEntryCubit>().updateVaccineeName(value);
              },
              bottomSheetTitle: "اختر اسم الطعم",
              searchHintText: "ابحث عن اسم الطعم",
            ),

            verticalSpacing(16),

            UserSelectionContainer(
              containerBorderColor: state.selectedDoseArrangement == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "ترتيب الجرعة", // Another Dropdown Example
              containerHintText:
                  state.selectedDoseArrangement ?? "اختر ترتيب الجرعة",
              options: state.doseArrangementData,
              onOptionSelected: (doseArrangment) {
                context
                    .read<VaccineDataEntryCubit>()
                    .updateDoseArrangement(doseArrangment);
              },
              bottomSheetTitle: "اختر ترتيب الجرعة",
              searchHintText: "ابحث عن ترتيب الجرعة",
            ),
            verticalSpacing(16),
            Text(
              "العمر النموذجى لتلقى التطعيم",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            CustomTextField(
              validator: (p0) {
                // return;
              },
              controller: TextEditingController(),
              keyboardType: TextInputType.number,
              hintText: state.vaccinePerfectAge ?? "اكتب العمر النموذجي",
              onChanged: (text) {},
            ),
            verticalSpacing(16),

            Text(
              "جهة تلقى التطعيم",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            CustomTextField(
              validator: (p0) {
                // return;
              },
              controller: context
                  .read<VaccineDataEntryCubit>()
                  .vaccinationLocationController,
              keyboardType: TextInputType.number,
              hintText: "من فضلك ادخل جهة تلقي التطعيم",
              onChanged: (text) {},
            ),
            UserSelectionContainer(
              categoryLabel: "الدولة",
              containerHintText: "اختر الدولة التى تم فيها التطعيم",
              options: state.countriesNames,
              onOptionSelected: (selectedCountry) {
                context.read<VaccineDataEntryCubit>().updateSelectedCountry(
                      selectedCountry,
                    );
              },
              bottomSheetTitle: "اختر الدولة التى تم فيها التطعيم",
              searchHintText: "ابحث عن الدولة",
            ),

            verticalSpacing(16),
            Text(
              "معلومات اضافية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            WordLimitTextField(
              controller:
                  context.read<VaccineDataEntryCubit>().personalNotesController,
              hintText: "اكتب باختصار أى معلومات اضافية مهمة",
            ),

            ///TODO: handle this button in main view and remove it from here
            /// send button
            verticalSpacing(32),
            submitXrayDataEntryButtonBlocConsumer(),
            verticalSpacing(71),
          ],
        );
      },
    );
  }

  Widget submitXrayDataEntryButtonBlocConsumer() {
    return BlocConsumer<VaccineDataEntryCubit, VaccineDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.vaccineDataEntryStatus == RequestStatus.failure ||
          curr.vaccineDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.vaccineDataEntryStatus != curr.vaccineDataEntryStatus,
      listener: (context, state) async {
        if (state.vaccineDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          context.pop(result: true);
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.vaccineDataEntryStatus == RequestStatus.loading,
          title: context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              state.isEditMode
                  ? await context
                      .read<VaccineDataEntryCubit>()
                      .submitEditVaccineData(S.of(context))
                  : await context
                      .read<VaccineDataEntryCubit>()
                      .postVaccineDataEntry(
                        S.of(context),
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
