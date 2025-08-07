import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/widgets/medicine_name_scanner_container.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class AddNewMedicationView extends StatelessWidget {
  const AddNewMedicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicinesDataEntryCubit, MedicinesDataEntryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0.h,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBarWidget(
                  haveBackArrow: true,
                ),
                verticalSpacing(16),
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
                AppCustomButton(
                  isLoading: false,
                  title: 'اضف دواء جديد',
                  onPressed: () async {
                    // if (state.isFormValidated) {
                    //   state.isEditMode
                    //       ? await context
                    //           .read<EmergencyComplaintsDataEntryCubit>()
                    //           .updateSpecifcEmergencyDocumentDataDetails(
                    //               context.translate)
                    //       : await context
                    //           .read<EmergencyComplaintsDataEntryCubit>()
                    //           .postEmergencyDataEntry(
                    //             context.translate,
                    //           );
                    // }
                  },
                  isEnabled: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
