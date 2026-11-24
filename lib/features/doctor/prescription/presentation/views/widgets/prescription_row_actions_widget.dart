import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Edit + delete buttons of a prescription table row.
class PrescriptionRowActionsWidget extends StatelessWidget {
  const PrescriptionRowActionsWidget({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RowActionButton(
          icon: Icons.edit_outlined,
          color: AppColorsManager.prescriptionActionBlue,
          backgroundColor: AppColorsManager.prescriptionEditActionBackground,
          tooltip: "تعديل",
          onPressed: onEdit,
        ),
        horizontalSpacing(6),
        _RowActionButton(
          icon: Icons.delete_outline,
          color: AppColorsManager.prescriptionDeleteAction,
          backgroundColor: AppColorsManager.prescriptionDeleteActionBackground,
          tooltip: "حذف",
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class _RowActionButton extends StatelessWidget {
  const _RowActionButton({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: onPressed,
          child: SizedBox(
            width: 30.w,
            height: 30.w,
            child: Icon(icon, size: 17.r, color: color),
          ),
        ),
      ),
    );
  }
}
