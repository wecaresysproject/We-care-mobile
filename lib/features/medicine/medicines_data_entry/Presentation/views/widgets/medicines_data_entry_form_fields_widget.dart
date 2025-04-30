import 'dart:async';

import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/Database/dummy_data.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/screens/edit_alarm.dart';
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
              containerHintText: state.selectedMedicineName ??
                  "اختر اسم الدواء", //state.doctorNameSelection ?? "اختر اسم الطبيب",
              options: state.medicinesNames,
              onOptionSelected: (value) async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedMedicineName(value);
              },
              bottomSheetTitle: "اختر اسم الدواء",
            ),
            verticalSpacing(16),

            MedicneNameScannerContainer(mounted: mounted, state: state),

            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.selectedMedicalForm == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "طريقة الاستخدام (الاشكال الدوائية)",
              containerHintText: state.selectedMedicalForm ??
                  state.selectedMedicalForm ??
                  "اختر طريقة الاستخدام", //state.doctorNameSelection ?? "اختر اسم الطبيب",
              options: state.medicineForms,
              onOptionSelected: (value) async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedMedicalForm(value);
              },
              bottomSheetTitle: "اختر طريقة الاستخدام",
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
              onOptionSelected: (value) {
                context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedDose(value);
              },
              bottomSheetTitle: "اختر كمية الجرعة",
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
              onOptionSelected: (value) {
                context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedDoseFrequency(value);
              },
              bottomSheetTitle: "اختر عدد مرات التناول ",
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
              onOptionSelected: (value) async {
                await context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedDoseDuration(value);
              },
              bottomSheetTitle: "اختر مدة استخدام الدواء",
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
              onOptionSelected: (value) {
                context
                    .read<MedicinesDataEntryCubit>()
                    .updateSelectedTimePeriod(value);
              },
              bottomSheetTitle: "اختر المدة الزمنية لمدة الاستخدام",
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
            ),

            verticalSpacing(16),

            buildMedicalComplaintsListBlocBuilder(),

            buildAddNewComplainButtonBlocBuilder(context),

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
            ),
            verticalSpacing(16),
            Text(
              "تنبيهات",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            CustomAlarmButton(
              containerHintText: state.selectedAlarmTime != null
                  ? 'تم ظبط منبه الدواء علي ${state.selectedAlarmTime}'
                  : 'اختر موعد التنبيه',
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

              // hintText: state.prescribtionEditedModel?.preDescriptionNotes ??
              //     "اكتب باختصار اى معلومات مهمة اخرى",
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

Widget buildAddNewComplainButtonBlocBuilder(BuildContext context) {
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
        color: AppColorsManager.mainDarkBlue, // Main color from Figma
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

class SymptomContainer extends StatelessWidget {
  const SymptomContainer({
    super.key,
    required this.isMainSymptom,
    required this.medicalComplaint,
    required this.onDelete,
  });

  final bool isMainSymptom;

  final MedicalComplaint medicalComplaint;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: isMainSymptom
          ? EdgeInsets.all(8)
          : EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColorsManager.mainDarkBlue, width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          if (isMainSymptom) // Conditionally render the main symptom title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "العرض المرضي الرئيسي",
                    style: AppTextStyles.font18blackWight500.copyWith(
                      color: AppColorsManager.mainDarkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ).paddingBottom(
                    16,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topCenter,
                  icon: Icon(
                    Icons.delete,
                    size: 28.sp,
                    color: AppColorsManager.warningColor,
                  ),
                )
              ],
            ),
          DetailsViewInfoTile(
            title: "الأعراض المرضية - المنطقة",
            value: medicalComplaint.symptomsRegion.substring(2).trim(),
            isExpanded: true,
            icon: 'assets/images/symptoms_icon.png',
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "الأعراض المرضية - الشكوى",
            value: medicalComplaint.sypmptomsComplaintIssue,
            isExpanded: true,
            icon: 'assets/images/symptoms_icon.png',
          ),
          verticalSpacing(16),
          Row(
            children: [
              DetailsViewInfoTile(
                title: "طبيعة الشكوى",
                value: medicalComplaint.natureOfComplaint,
                icon: 'assets/images/file_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "حدة الشكوى",
                value: medicalComplaint.severityOfComplaint,
                icon: 'assets/images/heart_rate_search_icon.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomAlarmButton extends StatefulWidget {
  final String containerHintText;
  const CustomAlarmButton({
    super.key,
    required this.containerHintText,
  });

  @override
  CustomAlarmButtonState createState() => CustomAlarmButtonState();
}

class CustomAlarmButtonState extends State<CustomAlarmButton> {
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final cubit = context.read<MedicinesDataEntryCubit>();
        final repeatEvery =
            cubit.getRepeatDurationFromText(cubit.state.selectedNoOfDose!);
        final totalDuartion =
            cubit.getTotalDurationFromText(cubit.state.timePeriods!);

        //!handle null values here later
        await openAlarmBottomSheet(
          null,
          repeatEvery: repeatEvery!,
          totalDuration: totalDuartion!,
        );
        // await context.pushNamed(Routes.alarmHomeView);
      },
      child: Container(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColorsManager.textfieldOutsideBorderColor,
            width: 0.8,
          ),
          color: AppColorsManager.textfieldInsideColor.withAlpha(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Row to include SVG icon and text
            Row(
              children: [
                Image.asset(
                  "assets/images/alarm_icon.png",
                  height: 28,
                  width: 28,
                  color: AppColorsManager.mainDarkBlue,
                ),
                const SizedBox(width: 16),
                Text(
                  _selectedTime ?? widget.containerHintText,
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    color: _selectedTime.isNotNull
                        ? AppColorsManager.textColor
                        : AppColorsManager.placeHolderColor,
                  ),
                ),
              ],
            ),

            /// Arrow icon to indicate dropdown state
            Image.asset(
              _selectedTime != null
                  ? "assets/images/arrow_up_icon.png"
                  : "assets/images/arrow_down_icon.png",
              height: 24,
              width: 16,
              color: AppColorsManager.mainDarkBlue,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openAlarmBottomSheet(
    AlarmSettings? settings, {
    required Duration repeatEvery,
    required Duration totalDuration,
  }) async {
    String? selectedAlarmTime;
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: AlarmEditScreen(
            alarmSettings: settings,
            onSave: (selectedDateTime) {
              selectedAlarmTime = selectedDateTime.toArabicTime();
            },
            repeatEvery: repeatEvery,
            totalDuration: totalDuration,
          ),
        );
      },
    );

    if (res != null && res == true && mounted) {
      context.read<MedicinesDataEntryCubit>().loadAlarms();
      context.read<MedicinesDataEntryCubit>().updateSelectedAlarmTime(
            selectedAlarmTime!,
          );
    }
  }
}
