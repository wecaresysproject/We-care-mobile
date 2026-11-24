import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_manual_entry_model.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_medicine_model.dart';
import 'package:we_care/features/doctor/prescription/logic/cubit/doctor_prescription_cubit.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_add_entry_options_sheet.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_manual_entries_table_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_manual_entry_sheet.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_medicine_form_sheet.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_medicines_table_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_section_card_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_table_cells_widget.dart';

/// Section "1 الأدوية": the medicines picked from the lists, the ones
/// written by hand under them, and the total count.
class PrescriptionMedicinesSectionWidget extends StatelessWidget {
  const PrescriptionMedicinesSectionWidget({super.key});

  Future<PrescriptionManualEntryModel?> _showManualSheet(
    BuildContext context, {
    PrescriptionManualEntryModel? initialEntry,
  }) {
    return PrescriptionManualEntrySheet.show(
      context,
      addTitle: "إضافة دواء يدويًا",
      editTitle: "تعديل الدواء",
      fieldLabel: "تفاصيل الدواء",
      hintText: "مثال: Augmentin 1g قرص كل 12 ساعة لمدة 7 أيام بعد الأكل",
      initialEntry: initialEntry,
    );
  }

  /// Asks list vs. manual first, then opens the matching sheet.
  Future<void> _addMedicine(BuildContext context) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final entryType = await PrescriptionAddEntryOptionsSheet.show(
      context,
      title: "إضافة دواء",
      fromListTitle: "اختيار من قائمة الأدوية",
      fromListSubtitle: "اختر اسم الدواء وطريقة الاستخدام والكمية والجرعة",
      manualSubtitle: "اكتب تفاصيل الدواء بنفسك كنص",
    );
    if (entryType == null || !context.mounted) return;

    switch (entryType) {
      case PrescriptionEntryType.fromList:
        final medicine = await PrescriptionMedicineFormSheet.show(context);
        if (medicine != null) cubit.addMedicine(medicine);
      case PrescriptionEntryType.manual:
        final medicine = await _showManualSheet(context);
        if (medicine != null) cubit.addManualMedicine(medicine);
    }
  }

  Future<void> _editMedicine(
    BuildContext context,
    int index,
    PrescriptionMedicineModel medicine,
  ) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final edited = await PrescriptionMedicineFormSheet.show(
      context,
      initialMedicine: medicine,
    );
    if (edited != null) cubit.updateMedicine(index, edited);
  }

  Future<void> _editManualMedicine(
    BuildContext context,
    int index,
    PrescriptionManualEntryModel medicine,
  ) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final edited = await _showManualSheet(context, initialEntry: medicine);
    if (edited != null) cubit.updateManualMedicine(index, edited);
  }

  Future<void> _deleteMedicine(
    BuildContext context,
    int index,
    PrescriptionMedicineModel medicine,
  ) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final isConfirmed = await confirmPrescriptionRowDelete(
      context,
      title: "حذف الدواء",
      message: "هل تريد حذف ${medicine.name} من الروشتة؟",
    );
    if (isConfirmed) cubit.removeMedicine(index);
  }

  Future<void> _deleteManualMedicine(BuildContext context, int index) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final isConfirmed = await confirmPrescriptionRowDelete(
      context,
      title: "حذف الدواء",
      message: "هل تريد حذف هذا الدواء من الروشتة؟",
    );
    if (isConfirmed) cubit.removeManualMedicine(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorPrescriptionCubit, DoctorPrescriptionState>(
      buildWhen: (previous, current) =>
          previous.medicines != current.medicines ||
          previous.manualMedicines != current.manualMedicines,
      builder: (context, state) {
        return PrescriptionSectionCardWidget(
          number: 1,
          icon: Icons.medication_outlined,
          title: "الأدوية",
          accentColor: AppColorsManager.prescriptionMedicinesAccent,
          headerBackgroundColor:
              AppColorsManager.prescriptionMedicinesHeaderBackground,
          addLabel: "إضافة دواء",
          onAddPressed: () => _addMedicine(context),
          footer: state.totalMedicines > 0
              ? "إجمالي الأدوية: ${state.totalMedicines}"
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.totalMedicines == 0)
                const PrescriptionEmptySectionWidget(
                  icon: Icons.medication_outlined,
                  title: "لم تتم إضافة أدوية بعد",
                  subtitle: "اضغط على \"إضافة دواء\" لإضافة أول دواء للروشتة",
                ),
              if (state.medicines.isNotEmpty)
                PrescriptionMedicinesTableWidget(
                  medicines: state.medicines,
                  onEdit: (index, medicine) =>
                      _editMedicine(context, index, medicine),
                  onDelete: (index, medicine) =>
                      _deleteMedicine(context, index, medicine),
                ),
              if (state.manualMedicines.isNotEmpty) ...[
                if (state.medicines.isNotEmpty) verticalSpacing(16),
                const PrescriptionSubTableTitle(
                  "أدوية مكتوبة يدويًا",
                  icon: Icons.edit_note_outlined,
                ),
                verticalSpacing(8),
                PrescriptionManualEntriesTableWidget(
                  detailsLabel: "تفاصيل الدواء",
                  entries: state.manualMedicines,
                  onEdit: (index, medicine) =>
                      _editManualMedicine(context, index, medicine),
                  onDelete: (index, _) => _deleteManualMedicine(context, index),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
