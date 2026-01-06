import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/medical_information_notice_widget.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/medication_compitability_action_button_widget.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';
import 'package:we_care/features/medicine/shared/widgets/medicine_name_scanner_container.dart';

class MedicationCompatibilityFormFieldsWidget extends StatelessWidget {
  const MedicationCompatibilityFormFieldsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicinesDataEntryCubit, MedicinesDataEntryState>(
      builder: (context, state) {
        return Column(
          children: [
            UserSelectionContainer(
              isEditMode: state.isEditMode,
              containerBorderColor: state.selectedMedicineName == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "اسم الدواء",
              containerHintText:
                  state.selectedMedicineName ?? "اختر اسم الدواء",
              options: state.medicinesNames,
              onOptionSelected: (value) async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedMedicineName(value);
              },
              bottomSheetTitle: "اختر اسم الدواء",
              searchHintText: "ابحث عن اسم الدواء",
              allowManualEntry: true,
              loadingState: state.medicinesNamesOptionsLoadingState,
              onRetryPressed: () async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .emitAllMedicinesNames();
              },
            ),
            verticalSpacing(16),
            MedicneNameScannerContainer(state: state),
            verticalSpacing(16),
            UserSelectionContainer(
              isEditMode: state.isEditMode,
              containerBorderColor: state.selectedMedicalForm == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "طريقة الاستخدام (الاشكال الدوائية)",
              containerHintText:
                  state.selectedMedicalForm ?? "اختر طريقة الاستخدام",
              options: state.medicineForms,
              loadingState: state.medicalFormsOptionsLoadingState,
              onOptionSelected: (value) async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedMedicalForm(value);
              },
              bottomSheetTitle: "اختر طريقة الاستخدام",
              searchHintText: "ابحث عن طريقة الاستخدام",
              onRetryPressed: () async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .emitMedicineforms();
              },
            ),
            verticalSpacing(16),
            UserSelectionContainer(
              isEditMode: state.isEditMode,
              allowManualEntry: true,
              containerBorderColor: state.selectedDose == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "الجرعة",
              containerHintText: state.selectedDose ?? "اختر كمية الجرعة",
              options: state.medicalDoses,
              loadingState: state.medicalDosesOptionsLoadingState,
              onOptionSelected: (value) {
                context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedDose(value);
              },
              bottomSheetTitle: "اختر كمية الجرعة",
              searchHintText: "ابحث عن كمية الجرعة",
              onRetryPressed: () async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .emitMedcineDosesByForms();
              },
            ),
            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,
              containerBorderColor: state.selectedDoseAmount == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "كمية الدواء",
              containerHintText: state.selectedDoseAmount ?? "اختر كمية الدواء",
              options: state.dosageAmounts,
              loadingState: state.dosageAmountOptionsLoadingState,
              onOptionSelected: (value) {
                context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedDoseAmount(value);
              },
              searchHintText: "ابحث عن كمية الدواء",
              bottomSheetTitle: "اختر كمية الدواء",
              onRetryPressed: () async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .emitAllDoseAmounts();
              },
            ),
            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,
              containerBorderColor: state.selectedNoOfDose == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "عدد مرات الجرعة",
              containerHintText:
                  state.selectedNoOfDose ?? "اختر عدد مرات التناول ",
              options: state.dosageFrequencies,
              loadingState: state.dosageFrequenciesOptionsLoadingState,
              onOptionSelected: (value) {
                context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedDoseFrequency(value);
              },
              searchHintText: "ابحث عن عدد مرات التناول ",
              bottomSheetTitle: "اختر عدد مرات التناول ",
              onRetryPressed: () async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .emitAllDosageFrequencies();
              },
            ),
            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,
              containerBorderColor: state.doseDuration == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "مدة الاستخدام",
              containerHintText:
                  state.doseDuration ?? "اختر مدة استخدام الدواء",
              options: state.allUsageCategories,
              loadingState: state.allUsageCategoriesOptionsLoadingState,
              onOptionSelected: (value) async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedDoseDuration(value);
              },
              bottomSheetTitle: "اختر مدة استخدام الدواء",
              searchHintText: "ابحث عن مدة استخدام الدواء",
              onRetryPressed: () async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .getAllUsageCategories();
              },
            ),
            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,
              containerBorderColor: state.timePeriods == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "المدد الزمنية",
              containerHintText:
                  state.timePeriods ?? "اختر المدة الزمنية لمدة الاستخدام",
              options: state.allDurationsBasedOnCategory,
              loadingState:
                  state.allDurationsBasedOnCategoryOptionsLoadingState,
              onOptionSelected: (value) {
                context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedTimePeriod(value);
              },
              bottomSheetTitle: "اختر المدة الزمنية لمدة الاستخدام",
              searchHintText: "ابحث عن المدة الزمنية لمدة الاستخدام",
              onRetryPressed: () async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .emitAllDurationsForCategory();
              },
            ),
            verticalSpacing(16),
            MedicationCompatibilityActionButton(),
            verticalSpacing(16),
            MedicalInformationNotice(),
            verticalSpacing(16),
          ],
        );
      },
    );
  }
}
