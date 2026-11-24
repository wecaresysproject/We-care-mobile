import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_manual_entry_model.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_table_cells_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_row_actions_widget.dart';

typedef PrescriptionManualEntryAction = void Function(
  int index,
  PrescriptionManualEntryModel entry,
);

const _numberFlex = 10;
const _detailsFlex = 62;
const _actionsFlex = 28;

/// Rows written by hand: # | [detailsLabel] | الإجراءات
class PrescriptionManualEntriesTableWidget extends StatelessWidget {
  const PrescriptionManualEntriesTableWidget({
    super.key,
    required this.detailsLabel,
    required this.entries,
    required this.onEdit,
    required this.onDelete,
  });

  /// "تفاصيل الدواء" / "تفاصيل الفحص"
  final String detailsLabel;
  final List<PrescriptionManualEntryModel> entries;
  final PrescriptionManualEntryAction onEdit;
  final PrescriptionManualEntryAction onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColorsManager.prescriptionTableDivider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: AppColorsManager.prescriptionTableHeaderBackground,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                const Expanded(
                  flex: _numberFlex,
                  child: PrescriptionTableHeaderText("#"),
                ),
                Expanded(
                  flex: _detailsFlex,
                  child: PrescriptionTableHeaderText(detailsLabel),
                ),
                const Expanded(
                  flex: _actionsFlex,
                  child: PrescriptionTableHeaderText("الإجراءات"),
                ),
              ],
            ),
          ),
          for (var i = 0; i < entries.length; i++) ...[
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColorsManager.prescriptionTableDivider,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    flex: _numberFlex,
                    child: PrescriptionTableBodyText("${i + 1}", isBold: true),
                  ),
                  Expanded(
                    flex: _detailsFlex,
                    child: PrescriptionTableBodyText(
                      entries[i].details,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: _actionsFlex,
                    child: Center(
                      child: PrescriptionRowActionsWidget(
                        onEdit: () => onEdit(i, entries[i]),
                        onDelete: () => onDelete(i, entries[i]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
