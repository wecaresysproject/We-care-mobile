import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_medicine_model.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_row_actions_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_table_cells_widget.dart';

typedef PrescriptionMedicineAction = void Function(
  int index,
  PrescriptionMedicineModel medicine,
);

/// One table column: header label and its minimum width (before `.w`).
class _TableColumn {
  const _TableColumn(this.label, this.minWidth);

  final String label;
  final double minWidth;
}

const _columns = [
  _TableColumn("الدواء", 110),
  _TableColumn("الكمية", 90),
  _TableColumn("الجرعة", 90),
  _TableColumn("المدة", 70),
  _TableColumn("التعليمات", 130),
  _TableColumn("الإجراءات", 84),
];

/// The medicines picked from the lists:
/// الدواء | الكمية | الجرعة | المدة | التعليمات | الإجراءات
///
/// Wider than a phone, so it scrolls horizontally; on wider screens the
/// columns stretch to fill the width.
class PrescriptionMedicinesTableWidget extends StatelessWidget {
  const PrescriptionMedicinesTableWidget({
    super.key,
    required this.medicines,
    required this.onEdit,
    required this.onDelete,
  });

  final List<PrescriptionMedicineModel> medicines;
  final PrescriptionMedicineAction onEdit;
  final PrescriptionMedicineAction onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColorsManager.prescriptionTableDivider),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minTotal =
              _columns.fold<double>(0, (sum, c) => sum + c.minWidth.w);
          final scale = constraints.maxWidth > minTotal
              ? constraints.maxWidth / minTotal
              : 1.0;
          final widths = [for (final c in _columns) c.minWidth.w * scale];
          final tableWidth = minTotal * scale;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: tableWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderRow(widths: widths),
                  for (var i = 0; i < medicines.length; i++) ...[
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColorsManager.prescriptionTableDivider,
                    ),
                    _MedicineRow(
                      widths: widths,
                      medicine: medicines[i],
                      onEdit: () => onEdit(i, medicines[i]),
                      onDelete: () => onDelete(i, medicines[i]),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.widths});

  final List<double> widths;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsManager.prescriptionTableHeaderBackground,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          for (var i = 0; i < _columns.length; i++)
            SizedBox(
              width: widths[i],
              child: PrescriptionTableHeaderText(_columns[i].label),
            ),
        ],
      ),
    );
  }
}

class _MedicineRow extends StatelessWidget {
  const _MedicineRow({
    required this.widths,
    required this.medicine,
    required this.onEdit,
    required this.onDelete,
  });

  final List<double> widths;
  final PrescriptionMedicineModel medicine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cells = [
      PrescriptionTableBodyText(medicine.name, isBold: true),
      PrescriptionTableBodyText(medicine.doseAmount),
      PrescriptionTableBodyText(medicine.doseFrequency),
      PrescriptionTableBodyText(medicine.duration),
      PrescriptionTableBodyText(
        medicine.instructions.isEmpty ? "—" : medicine.instructions,
      ),
      Center(
        child: PrescriptionRowActionsWidget(onEdit: onEdit, onDelete: onDelete),
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          for (var i = 0; i < cells.length; i++)
            SizedBox(width: widths[i], child: cells[i]),
        ],
      ),
    );
  }
}
