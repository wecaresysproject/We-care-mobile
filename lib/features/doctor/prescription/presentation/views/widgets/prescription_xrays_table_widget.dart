import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_xray_model.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_row_actions_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_table_cells_widget.dart';

typedef PrescriptionXRayAction = void Function(
  int index,
  PrescriptionXRayModel xRay,
);

const _bodyPartFlex = 24;
const _typeFlex = 24;
const _purposesFlex = 28;
const _actionsFlex = 24;

/// The X-rays picked from the lists:
/// منطقة الأشعة | النوع | نوعية الاحتياج | الإجراءات
class PrescriptionXRaysTableWidget extends StatelessWidget {
  const PrescriptionXRaysTableWidget({
    super.key,
    required this.xRays,
    required this.onEdit,
    required this.onDelete,
  });

  final List<PrescriptionXRayModel> xRays;
  final PrescriptionXRayAction onEdit;
  final PrescriptionXRayAction onDelete;

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
                  flex: _bodyPartFlex,
                  child: PrescriptionTableHeaderText("منطقة الأشعة"),
                ),
                Expanded(
                  flex: _typeFlex,
                  child: PrescriptionTableHeaderText("النوع"),
                ),
                Expanded(
                  flex: _purposesFlex,
                  child: PrescriptionTableHeaderText("نوعية الاحتياج"),
                ),
                Expanded(
                  flex: _actionsFlex,
                  child: PrescriptionTableHeaderText("الإجراءات"),
                ),
              ],
            ),
          ),
          for (var i = 0; i < xRays.length; i++) ...[
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
                    flex: _bodyPartFlex,
                    child: PrescriptionTableBodyText(
                      xRays[i].bodyPart,
                      isBold: true,
                    ),
                  ),
                  Expanded(
                    flex: _typeFlex,
                    child: PrescriptionTableBodyText(xRays[i].type),
                  ),
                  Expanded(
                    flex: _purposesFlex,
                    child: PrescriptionTableBodyText(
                      xRays[i].purposes.isEmpty
                          ? "—"
                          : xRays[i].purposes.join("، "),
                    ),
                  ),
                  Expanded(
                    flex: _actionsFlex,
                    child: Center(
                      child: PrescriptionRowActionsWidget(
                        onEdit: () => onEdit(i, xRays[i]),
                        onDelete: () => onDelete(i, xRays[i]),
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
