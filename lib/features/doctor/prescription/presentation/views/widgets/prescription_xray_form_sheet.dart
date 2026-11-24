import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_xray_model.dart';
import 'package:we_care/features/doctor/prescription/logic/cubit/prescription_xray_form_cubit.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_sheet_header_widget.dart';

/// Bottom sheet for adding or editing one X-ray of the prescription. Pops
/// with the filled [PrescriptionXRayModel], or null when dismissed.
class PrescriptionXRayFormSheet extends StatelessWidget {
  const PrescriptionXRayFormSheet({super.key});

  static Future<PrescriptionXRayModel?> show(
    BuildContext context, {
    PrescriptionXRayModel? initialXRay,
  }) {
    return showModalBottomSheet<PrescriptionXRayModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => BlocProvider<PrescriptionXRayFormCubit>(
        create: (_) => getIt<PrescriptionXRayFormCubit>()..init(initialXRay),
        child: const PrescriptionXRayFormSheet(),
      ),
    );
  }

  Color _borderFor(String? value) => value == null || value.trim().isEmpty
      ? AppColorsManager.warningColor
      : AppColorsManager.textfieldOutsideBorderColor;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PrescriptionXRayFormCubit>();

    return BlocBuilder<PrescriptionXRayFormCubit, PrescriptionXRayFormState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrescriptionSheetHeaderWidget(
                title: state.isEditMode ? "تعديل الأشعة" : "إضافة أشعة",
                icon: Icons.medical_information_outlined,
              ),
              verticalSpacing(20),
              UserSelectionContainer(
                categoryLabel: "منطقة الأشعة",
                containerHintText:
                    state.selectedBodyPart ?? "اختر العضو الخاص بالأشعة",
                initialValue: state.selectedBodyPart,
                containerBorderColor: _borderFor(state.selectedBodyPart),
                options: state.bodyPartNames,
                loadingState: state.bodyPartsLoadingState,
                allowManualEntry: true,
                onOptionSelected: cubit.updateBodyPart,
                onRetryPressed: cubit.loadBodyParts,
                bottomSheetTitle: "اختر العضو الخاص بالأشعة",
                searchHintText: "ابحث عن العضو الخاص بالأشعة",
              ),
              verticalSpacing(16),
              UserSelectionContainer(
                categoryLabel: "النوع",
                containerHintText: state.selectedType ?? "اختر نوع الأشعة",
                initialValue: state.selectedType,
                containerBorderColor: _borderFor(state.selectedType),
                options: state.typeNames,
                loadingState: state.typesLoadingState,
                allowManualEntry: true,
                onOptionSelected: cubit.updateType,
                onRetryPressed: cubit.loadTypes,
                bottomSheetTitle: "اختر نوع الأشعة",
                searchHintText: "ابحث عن نوع الأشعة",
              ),
              verticalSpacing(16),
              UserSelectionContainer(
                // A fresh widget per selection, so the field shows the count
                // instead of the last picked purpose.
                key: ValueKey(state.selectedPurposes.join('|')),
                categoryLabel: "نوعية الاحتياج للأشعة",
                containerHintText: state.selectedPurposes.isEmpty
                    ? "اختر نوعية احتياجك للأشعة"
                    : "${state.selectedPurposes.length} تم اختيارهم",
                options: state.purposeOptions,
                allowManualEntry: true,
                onOptionSelected: cubit.togglePurpose,
                bottomSheetTitle: "اختر نوعية احتياجك للأشعة",
                searchHintText: "ابحث عن نوعية احتياجك للأشعة",
              ),
              if (state.selectedPurposes.isNotEmpty) ...[
                verticalSpacing(10),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    for (final purpose in state.selectedPurposes)
                      _PurposeChip(
                        label: purpose,
                        onRemove: () => cubit.removePurpose(purpose),
                      ),
                  ],
                ),
              ],
              verticalSpacing(28),
              AppCustomButton(
                title: state.isEditMode ? "حفظ التعديلات" : "إضافة للروشتة",
                textFontSize: 18,
                isEnabled: state.isFormValid,
                onPressed: () {
                  final xRay = cubit.buildXRay();
                  if (xRay != null) Navigator.of(context).pop(xRay);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PurposeChip extends StatelessWidget {
  const _PurposeChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColorsManager.prescriptionEditActionBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColorsManager.prescriptionActionBlue.withAlpha(90),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: AppColorsManager.prescriptionTitleColor,
              ),
            ),
          ),
          horizontalSpacing(6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 16.r,
              color: AppColorsManager.prescriptionDeleteAction,
            ),
          ),
        ],
      ),
    );
  }
}
