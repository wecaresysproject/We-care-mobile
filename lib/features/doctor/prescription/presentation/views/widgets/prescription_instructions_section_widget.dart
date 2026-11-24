import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_manual_entry_model.dart';
import 'package:we_care/features/doctor/prescription/logic/cubit/doctor_prescription_cubit.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_manual_entry_sheet.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_row_actions_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_section_card_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_table_cells_widget.dart';

/// Section "3 تعليمات للمريض": a bulleted list of free-text instructions.
class PrescriptionInstructionsSectionWidget extends StatelessWidget {
  const PrescriptionInstructionsSectionWidget({super.key});

  Future<PrescriptionManualEntryModel?> _showSheet(
    BuildContext context, {
    PrescriptionManualEntryModel? initialEntry,
  }) {
    return PrescriptionManualEntrySheet.show(
      context,
      addTitle: "إضافة تعليمات للمريض",
      editTitle: "تعديل التعليمات",
      fieldLabel: initialEntry == null
          ? "التعليمات (كل سطر تعليمة منفصلة)"
          : "التعليمات",
      hintText: "مثال: الإكثار من شرب السوائل",
      initialEntry: initialEntry,
    );
  }

  /// Each written line becomes its own bullet.
  Future<void> _addInstructions(BuildContext context) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final entry = await _showSheet(context);
    if (entry == null) return;
    final instructions = entry.details
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .map((line) => PrescriptionManualEntryModel(details: line))
        .toList();
    cubit.addPatientInstructions(instructions);
  }

  Future<void> _editInstruction(
    BuildContext context,
    int index,
    PrescriptionManualEntryModel instruction,
  ) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final edited = await _showSheet(context, initialEntry: instruction);
    if (edited != null) cubit.updatePatientInstruction(index, edited);
  }

  Future<void> _deleteInstruction(BuildContext context, int index) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final isConfirmed = await confirmPrescriptionRowDelete(
      context,
      title: "حذف التعليمات",
      message: "هل تريد حذف هذه التعليمات من الروشتة؟",
    );
    if (isConfirmed) cubit.removePatientInstruction(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorPrescriptionCubit, DoctorPrescriptionState>(
      buildWhen: (previous, current) =>
          previous.patientInstructions != current.patientInstructions,
      builder: (context, state) {
        final instructions = state.patientInstructions;

        return PrescriptionSectionCardWidget(
          number: 3,
          icon: Icons.description_outlined,
          title: "تعليمات للمريض",
          accentColor: AppColorsManager.prescriptionInstructionsAccent,
          headerBackgroundColor:
              AppColorsManager.prescriptionInstructionsHeaderBackground,
          addLabel: "إضافة تعليمات",
          onAddPressed: () => _addInstructions(context),
          child: instructions.isEmpty
              ? const PrescriptionEmptySectionWidget(
                  icon: Icons.description_outlined,
                  title: "لم تتم إضافة تعليمات بعد",
                  subtitle: "اضغط على \"إضافة تعليمات\" لإضافة أول تعليمة",
                )
              : Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColorsManager.prescriptionTableDivider,
                    ),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < instructions.length; i++)
                        _InstructionRow(
                          text: instructions[i].details,
                          onEdit: () =>
                              _editInstruction(context, i, instructions[i]),
                          onDelete: () => _deleteInstruction(context, i),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _InstructionRow extends StatelessWidget {
  const _InstructionRow({
    required this.text,
    required this.onEdit,
    required this.onDelete,
  });

  final String text;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 7.h),
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: const BoxDecoration(
                color: AppColorsManager.prescriptionSubtitleColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          horizontalSpacing(10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: AppColorsManager.prescriptionTableText,
                height: 1.5,
              ),
            ),
          ),
          horizontalSpacing(8),
          PrescriptionRowActionsWidget(onEdit: onEdit, onDelete: onDelete),
        ],
      ),
    );
  }
}
