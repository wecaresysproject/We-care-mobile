import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_medicine_model.dart';
import 'package:we_care/features/doctor/prescription/logic/cubit/prescription_medicine_form_cubit.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_multiline_text_field.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_sheet_header_widget.dart';

/// Bottom sheet for adding or editing one prescription medicine. Pops with
/// the filled [PrescriptionMedicineModel], or null when dismissed.
class PrescriptionMedicineFormSheet extends StatefulWidget {
  const PrescriptionMedicineFormSheet({super.key, this.initialMedicine});

  final PrescriptionMedicineModel? initialMedicine;

  static Future<PrescriptionMedicineModel?> show(
    BuildContext context, {
    PrescriptionMedicineModel? initialMedicine,
  }) {
    return showModalBottomSheet<PrescriptionMedicineModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => BlocProvider<PrescriptionMedicineFormCubit>(
        create: (_) =>
            getIt<PrescriptionMedicineFormCubit>()..init(initialMedicine),
        child: PrescriptionMedicineFormSheet(initialMedicine: initialMedicine),
      ),
    );
  }

  @override
  State<PrescriptionMedicineFormSheet> createState() =>
      _PrescriptionMedicineFormSheetState();
}

class _PrescriptionMedicineFormSheetState
    extends State<PrescriptionMedicineFormSheet> {
  late final TextEditingController _durationController =
      TextEditingController(text: widget.initialMedicine?.duration);
  late final TextEditingController _instructionsController =
      TextEditingController(text: widget.initialMedicine?.instructions);

  @override
  void dispose() {
    _durationController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Color _borderFor(String? value) => value == null || value.trim().isEmpty
      ? AppColorsManager.warningColor
      : AppColorsManager.textfieldOutsideBorderColor;

  void _submit() {
    final medicine =
        context.read<PrescriptionMedicineFormCubit>().buildMedicine();
    if (medicine == null) return;
    Navigator.of(context).pop(medicine);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PrescriptionMedicineFormCubit>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: BlocBuilder<PrescriptionMedicineFormCubit,
          PrescriptionMedicineFormState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrescriptionSheetHeaderWidget(
                  title: state.isEditMode ? "تعديل الدواء" : "إضافة دواء",
                ),
                verticalSpacing(20),
                UserSelectionContainer(
                  categoryLabel: "اسم الدواء",
                  containerHintText:
                      state.selectedMedicineName ?? "اختر اسم الدواء",
                  initialValue: state.selectedMedicineName,
                  containerBorderColor: _borderFor(state.selectedMedicineName),
                  options: state.medicinesNames,
                  loadingState: state.namesLoadingState,
                  allowManualEntry: true,
                  onOptionSelected: cubit.updateMedicineName,
                  onRetryPressed: cubit.loadMedicinesNames,
                  bottomSheetTitle: "اختر اسم الدواء",
                  searchHintText: "ابحث عن اسم الدواء",
                ),
                verticalSpacing(16),
                UserSelectionContainer(
                  categoryLabel: "طريقة الاستخدام (الاشكال الدوائية)",
                  containerHintText:
                      state.selectedMedicalForm ?? "اختر طريقة الاستخدام",
                  initialValue: state.selectedMedicalForm,
                  containerBorderColor: _borderFor(state.selectedMedicalForm),
                  options: state.medicalForms,
                  loadingState: state.formsLoadingState,
                  allowManualEntry: true,
                  onOptionSelected: cubit.updateMedicalForm,
                  onRetryPressed: cubit.loadMedicalForms,
                  bottomSheetTitle: "اختر طريقة الاستخدام",
                  searchHintText: "ابحث عن طريقة الاستخدام",
                ),
                verticalSpacing(16),
                UserSelectionContainer(
                  categoryLabel: "كمية الدواء",
                  containerHintText:
                      state.selectedDoseAmount ?? "اختر كمية الدواء",
                  initialValue: state.selectedDoseAmount,
                  containerBorderColor: _borderFor(state.selectedDoseAmount),
                  options: state.doseAmounts,
                  loadingState: state.doseAmountsLoadingState,
                  allowManualEntry: true,
                  onOptionSelected: cubit.updateDoseAmount,
                  onRetryPressed: cubit.loadDoseAmounts,
                  bottomSheetTitle: "اختر كمية الدواء",
                  searchHintText: "ابحث عن كمية الدواء",
                ),
                verticalSpacing(16),
                UserSelectionContainer(
                  categoryLabel: "عدد مرات الجرعة",
                  containerHintText:
                      state.selectedDoseFrequency ?? "اختر عدد مرات التناول",
                  initialValue: state.selectedDoseFrequency,
                  containerBorderColor: _borderFor(state.selectedDoseFrequency),
                  options: state.dosageFrequencies,
                  loadingState: state.frequenciesLoadingState,
                  allowManualEntry: true,
                  onOptionSelected: cubit.updateDoseFrequency,
                  onRetryPressed: cubit.loadDosageFrequencies,
                  bottomSheetTitle: "اختر عدد مرات التناول",
                  searchHintText: "ابحث عن عدد مرات التناول",
                ),
                verticalSpacing(16),
                Text("مدة الاستخدام", style: AppTextStyles.font18blackWight500),
                verticalSpacing(10),
                CustomTextField(
                  controller: _durationController,
                  hintText: "مثال: 7 أيام",
                  onChanged: cubit.updateDuration,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "هذا الحقل مطلوب"
                      : null,
                ),
                verticalSpacing(16),
                Text("تعليمات", style: AppTextStyles.font18blackWight500),
                verticalSpacing(10),
                PrescriptionMultilineTextField(
                  controller: _instructionsController,
                  hintText: "مثال: بعد الأكل",
                  minLines: 2,
                  onChanged: cubit.updateInstructions,
                ),
                verticalSpacing(28),
                AppCustomButton(
                  title: state.isEditMode ? "حفظ التعديلات" : "إضافة للروشتة",
                  textFontSize: 18,
                  isEnabled: state.isFormValid,
                  onPressed: _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
