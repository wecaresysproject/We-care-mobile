import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_lab_test_model.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_row_actions_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_table_cells_widget.dart';

typedef PrescriptionLabTestAction = void Function(
  int index,
  PrescriptionLabTestModel labTest,
);

const _groupFlex = 38;
const _nameFlex = 38;
const _actionsFlex = 24;

/// The lab tests picked from the lists: المجموعة | التحاليل | الإجراءات
class PrescriptionLabTestsTableWidget extends StatelessWidget {
  const PrescriptionLabTestsTableWidget({
    super.key,
    required this.labTests,
    required this.onEdit,
    required this.onDelete,
  });

  final List<PrescriptionLabTestModel> labTests;
  final PrescriptionLabTestAction onEdit;
  final PrescriptionLabTestAction onDelete;

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
            child: const Row(
              children: [
                Expanded(
                  flex: _groupFlex,
                  child: PrescriptionTableHeaderText("المجموعة"),
                ),
                Expanded(
                  flex: _nameFlex,
                  child: PrescriptionTableHeaderText("التحاليل"),
                ),
                Expanded(
                  flex: _actionsFlex,
                  child: PrescriptionTableHeaderText("الإجراءات"),
                ),
              ],
            ),
          ),
          for (var i = 0; i < labTests.length; i++) ...[
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
                    flex: _groupFlex,
                    child: PrescriptionTableBodyText(
                      labTests[i].groupName ?? "—",
                    ),
                  ),
                  Expanded(
                    flex: _nameFlex,
                    child: PrescriptionTableBodyText(
                      labTests[i].testNames.isEmpty
                          ? "—"
                          : labTests[i].testNames.join("\n"),
                    ),
                  ),
                  Expanded(
                    flex: _actionsFlex,
                    child: Center(
                      child: PrescriptionRowActionsWidget(
                        onEdit: () => onEdit(i, labTests[i]),
                        onDelete: () => onDelete(i, labTests[i]),
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
