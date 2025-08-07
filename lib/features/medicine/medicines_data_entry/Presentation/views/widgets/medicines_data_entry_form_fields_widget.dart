import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/Database/dummy_data.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/add_new_medical_complaint_button.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/Presentation/views/widgets/emergency_complaints_data_entry_form_fields_widget.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/widgets/custom_alarm_button.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/widgets/medicine_name_scanner_container.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicinesDataEntryFormFieldsWidget extends StatefulWidget {
  const MedicinesDataEntryFormFieldsWidget({super.key});

  @override
  State<MedicinesDataEntryFormFieldsWidget> createState() =>
      _MedicinesDataEntryFormFieldsWidgetState();
}

class _MedicinesDataEntryFormFieldsWidgetState
    extends State<MedicinesDataEntryFormFieldsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicinesDataEntryCubit, MedicinesDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ بدء الدواء",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              containerBorderColor: state.medicineStartDate == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText: state.medicineStartDate ?? "يوم / شهر / سنة",
              onDateSelected: (pickedDate) {
                context
                    .read<MedicinesDataEntryCubit>()
                    .updateStartMedicineDate(pickedDate);
              },
            ),

            verticalSpacing(16),
            UserSelectionContainer(
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

            UserSelectionContainer(
              categoryLabel: "دواء مرض مزمن",
              containerHintText:
                  state.selectedChronicDisease ?? "اختر اسم دواء مرض مزمن",
              options: [
                "باطنة",
                "جراحة",
                "طبيب عام",
                "طبيب اطفال",
                "طبيب جراحة",
              ],
              onOptionSelected: (value) {
                context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedChronicDisease(value);
              },
              bottomSheetTitle: "اختر اسم دواء مرض مزمن",
              searchHintText: "ابحث عن اسم دواء مرض مزمن",
            ),

            verticalSpacing(16),

            buildMedicalComplaintsListBlocBuilder(),

            buildAddNewComplainButtonBlocBuilder(),

            verticalSpacing(16),

            UserSelectionContainer(
              allowManualEntry: true,
              options: doctorsList,
              categoryLabel: "اسم الطبيب",
              bottomSheetTitle: "اختر اسم الطبيب",
              onOptionSelected: (value) {
                context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedDoctorName(value);
              },
              containerHintText: state.selectedDoctorName ?? "اختر اسم الطبيب",
              searchHintText: "ابحث عن اسم الطبيب",
            ),
            verticalSpacing(16),
            Text(
              "تنبيهات",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            CustomAlarmButton(
              containerHintText: state.selectedAlarmTime != null &&
                      state.selectedAlarmTime != ''
                  ? 'تم ظبط موعد الدواء علي ${state.selectedAlarmTime}'
                  : 'اختر موعد التنبيه',
            ),
            verticalSpacing(10),

            Text(
              'إذا لم يظهر زر الإيقاف، افتح مركز الإشعارات واسحب الإشعار لأسفل لرؤية الزر.',
              style: AppTextStyles.font14BlueWeight700.copyWith(
                color: AppColorsManager.warningColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),

            verticalSpacing(16),
            Text(
              "ملاحظات شخصية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            WordLimitTextField(
              controller: context
                  .read<MedicinesDataEntryCubit>()
                  .personalInfoController,
              hintText: "اكتب باختصار اى معلومات مهمة اخرى",
            ),

            ///TODO: handle this button in main view and remove it from here
            /// final section
            verticalSpacing(32),

            submitEmergencyDataEnteredBlocConsumer(),

            verticalSpacing(71),
          ],
        );
      },
    );
  }
}

Widget buildAddNewComplainButtonBlocBuilder() {
  return BlocBuilder<MedicinesDataEntryCubit, MedicinesDataEntryState>(
    buildWhen: (previous, current) =>
        current.medicalComplaints.length != previous.medicalComplaints.length,
    builder: (context, state) {
      return Center(
        child: AddNewMedicalComplaintButton(
          text: state.medicalComplaints.isEmpty
              ? "أضف أعراض مرضية"
              : 'أضف أعراض مرضية أخرى ان وجد',
          onPressed: () async {
            final bool? result = await context.pushNamed(
              Routes.medicationSymptomsFormFieldView,
            );

            if (result != null && context.mounted) {
              await context
                  .read<MedicinesDataEntryCubit>()
                  .fetchAllAddedComplaints();
            }
          },
        ),
      );
    },
  );
}

Widget buildMedicalComplaintsListBlocBuilder() {
  return BlocBuilder<MedicinesDataEntryCubit, MedicinesDataEntryState>(
    buildWhen: (previous, current) =>
        previous.medicalComplaints != current.medicalComplaints,
    builder: (context, state) {
      return state.medicalComplaints.isNotEmpty
          ? ListView.builder(
              itemCount: state.medicalComplaints.length,
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // Prevents scrolling within ListView
              itemBuilder: (context, index) {
                final complaint = state.medicalComplaints[index];
                return GestureDetector(
                  onTap: () async {
                    final bool? result = await context.pushNamed(
                      Routes.addNewComplaintDetails,
                      arguments: {
                        'id': index,
                        'complaint': complaint,
                      },
                    );
                    if (result != null && context.mounted) {
                      await context
                          .read<MedicinesDataEntryCubit>()
                          .fetchAllAddedComplaints();
                    }
                  },
                  child: SymptomContainer(
                    medicalComplaint: complaint,
                    isMainSymptom: true,
                    onDelete: () async {
                      final cubit = context.read<MedicinesDataEntryCubit>();
                      await cubit.removeAddedMedicalComplaint(index);
                      await cubit.fetchAllAddedComplaints();
                    },
                  ).paddingBottom(
                    16,
                  ),
                );
              },
            )
          : const SizedBox.shrink();
    },
  );
}

Widget submitEmergencyDataEnteredBlocConsumer() {
  return BlocConsumer<MedicinesDataEntryCubit, MedicinesDataEntryState>(
    listenWhen: (prev, curr) =>
        curr.medicinesDataEntryStatus == RequestStatus.failure ||
        curr.medicinesDataEntryStatus == RequestStatus.success,
    buildWhen: (prev, curr) =>
        prev.isFormValidated != curr.isFormValidated ||
        prev.medicinesDataEntryStatus != curr.medicinesDataEntryStatus,
    listener: (context, state) async {
      if (state.medicinesDataEntryStatus == RequestStatus.success) {
        await showSuccess(state.message);
        if (!context.mounted) return;
        //* in order to catch it again to rebuild details view
        context.pop(
          result: true,
        );
      } else {
        await showError(state.message);
      }
    },
    builder: (context, state) {
      return AppCustomButton(
        isLoading: state.medicinesDataEntryStatus == RequestStatus.loading,
        title: state.isEditMode ? "تحديت البيانات" : context.translate.send,
        onPressed: () async {
          if (state.isFormValidated) {
            state.isEditMode
                ? await context
                    .read<MedicinesDataEntryCubit>()
                    .submitEditsForMedicine()
                : await context
                    .read<MedicinesDataEntryCubit>()
                    .postMedicinesDataEntry(
                      context.translate,
                    );
          }
        },
        isEnabled: state.isFormValidated ? true : false,
      );
    },
  );
}
