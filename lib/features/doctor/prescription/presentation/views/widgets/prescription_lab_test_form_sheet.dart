import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_lab_test_model.dart';
import 'package:we_care/features/doctor/prescription/logic/cubit/prescription_lab_test_form_cubit.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_group_tests_selector_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_sheet_header_widget.dart';

/// Bottom sheet for adding or editing one lab test of the prescription.
/// Pops with the filled [PrescriptionLabTestModel], or null when dismissed.
class PrescriptionLabTestFormSheet extends StatelessWidget {
  const PrescriptionLabTestFormSheet({super.key});

  static Future<PrescriptionLabTestModel?> show(
    BuildContext context, {
    PrescriptionLabTestModel? initialLabTest,
  }) {
    return showModalBottomSheet<PrescriptionLabTestModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => BlocProvider<PrescriptionLabTestFormCubit>(
        create: (_) =>
            getIt<PrescriptionLabTestFormCubit>()..init(initialLabTest),
        child: const PrescriptionLabTestFormSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PrescriptionLabTestFormCubit>();

    return BlocBuilder<PrescriptionLabTestFormCubit,
        PrescriptionLabTestFormState>(
      builder: (context, state) {
        // One of the two is needed, so both warn only while both are empty.
        final isEmpty = !state.hasGroup && !state.hasTestNameEn;
        final activeBorder = isEmpty
            ? AppColorsManager.warningColor
            : AppColorsManager.textfieldOutsideBorderColor;
        final lockedBorder =
            AppColorsManager.disAbledTextFieldOutsideBorderColor;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrescriptionSheetHeaderWidget(
                title: state.isEditMode ? "تعديل التحليل" : "إضافة تحليل",
                icon: Icons.bloodtype_outlined,
              ),
              verticalSpacing(8),
              Text(
                "اختر المجموعة أو اسم التحليل — اختيار أحدهما يقفل الآخر",
                style: AppTextStyles.font13GreyWeight400.copyWith(
                  color: AppColorsManager.prescriptionSubtitleColor,
                ),
              ),
              verticalSpacing(16),
              _ClearableSelection(
                isSelected: state.hasGroup,
                onClear: cubit.clearGroupName,
                child: UserSelectionContainer(
                  categoryLabel: "المجموعة",
                  containerHintText: state.selectedGroupName ?? "اختر المجموعة",
                  initialValue: state.selectedGroupName,
                  // Locked while an English test name is picked.
                  isDisabled: state.hasTestNameEn,
                  containerBorderColor:
                      state.hasTestNameEn ? lockedBorder : activeBorder,
                  iconColor: state.hasTestNameEn
                      ? AppColorsManager.disAbledIconColor
                      : AppColorsManager.mainDarkBlue,
                  options: state.groupNames,
                  loadingState: state.groupsLoadingState,
                  allowManualEntry: true,
                  onOptionSelected: cubit.updateGroupName,
                  onRetryPressed: cubit.loadGroupNames,
                  bottomSheetTitle: "اختر اسم المجموعة",
                  searchHintText: "ابحث عن اسم المجموعة",
                ),
              ),
              verticalSpacing(16),
              _ClearableSelection(
                isSelected: state.hasTestNameEn,
                onClear: cubit.clearTestNameEn,
                child: UserSelectionContainer(
                  categoryLabel: "الاسم (En)",
                  containerHintText:
                      state.selectedTestNameEn ?? "اختر اسم التحليل",
                  initialValue: state.selectedTestNameEn,
                  // Locked while a group is picked.
                  isDisabled: state.hasGroup,
                  containerBorderColor:
                      state.hasGroup ? lockedBorder : activeBorder,
                  iconColor: state.hasGroup
                      ? AppColorsManager.disAbledIconColor
                      : AppColorsManager.mainDarkBlue,
                  options: state.testNamesEn,
                  loadingState: state.testNamesEnLoadingState,
                  allowManualEntry: true,
                  onOptionSelected: cubit.updateTestNameEn,
                  onRetryPressed: cubit.loadTestNamesEn,
                  bottomSheetTitle: "اختر اسم التحليل",
                  searchHintText: "ابحث عن اسم التحليل",
                ),
              ),
              if (state.hasGroup || state.hasTestNameEn) ...[
                verticalSpacing(16),
                PrescriptionGroupTestsSelectorWidget(
                  tests: state.groupTests,
                  selectedTests: state.selectedGroupTests,
                  loadingState: state.groupTestsLoadingState,
                  onToggle: cubit.toggleGroupTest,
                  onToggleAll: cubit.toggleAllGroupTests,
                  onRetry: cubit.loadTests,
                ),
              ],
              verticalSpacing(28),
              AppCustomButton(
                title: state.isEditMode ? "حفظ التعديلات" : "إضافة للروشتة",
                textFontSize: 18,
                isEnabled: state.isFormValid,
                onPressed: () {
                  final labTest = cubit.buildLabTest();
                  if (labTest != null) Navigator.of(context).pop(labTest);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Adds a "مسح" action beside a selection's label — clearing one field
/// unlocks the other.
class _ClearableSelection extends StatelessWidget {
  const _ClearableSelection({
    required this.isSelected,
    required this.onClear,
    required this.child,
  });

  final bool isSelected;
  final VoidCallback onClear;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isSelected)
          PositionedDirectional(
            top: 0,
            end: 0,
            child: GestureDetector(
              onTap: onClear,
              child: Text(
                "مسح",
                style: AppTextStyles.font14BlueWeight700.copyWith(
                  color: AppColorsManager.prescriptionDeleteAction,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
