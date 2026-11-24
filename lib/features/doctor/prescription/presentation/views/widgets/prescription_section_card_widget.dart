import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// One numbered prescription section ("1 الأدوية", "2 الفحوصات"): a tinted
/// header with the add button, then [child], then an optional [footer]
/// line such as the total count.
class PrescriptionSectionCardWidget extends StatelessWidget {
  const PrescriptionSectionCardWidget({
    super.key,
    required this.number,
    required this.icon,
    required this.title,
    required this.accentColor,
    required this.headerBackgroundColor,
    required this.addLabel,
    required this.onAddPressed,
    required this.child,
    this.footer,
  });

  final int number;
  final IconData icon;
  final String title;
  final Color accentColor;
  final Color headerBackgroundColor;

  /// "إضافة دواء"
  final String addLabel;
  final VoidCallback onAddPressed;
  final Widget child;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColorsManager.prescriptionCardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: headerBackgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 26.w,
                  height: 26.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "$number",
                    style: AppTextStyles.font14whiteWeight600,
                  ),
                ),
                horizontalSpacing(8),
                Icon(icon, size: 20.r, color: accentColor),
                horizontalSpacing(6),
                // One line on any width: the title shrinks instead of
                // wrapping letter by letter on small phones.
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      title,
                      maxLines: 1,
                      style: AppTextStyles.font18blackWight500.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                horizontalSpacing(8),
                _AddButton(label: addLabel, onPressed: onAddPressed),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: child,
          ),
          if (footer != null)
            Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: Text(
                footer!,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14GreyWeight400.copyWith(
                  color: AppColorsManager.prescriptionSubtitleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColorsManager.prescriptionActionBlue),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                size: 18.r,
                color: AppColorsManager.prescriptionActionBlue,
              ),
              horizontalSpacing(4),
              Text(
                label,
                style: AppTextStyles.font14BlueWeight700.copyWith(
                  color: AppColorsManager.prescriptionActionBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small title above a table inside a section, e.g. "مكتوبة يدويًا".
class PrescriptionSubTableTitle extends StatelessWidget {
  const PrescriptionSubTableTitle(this.title, {super.key, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: AppColorsManager.prescriptionTitleColor),
        horizontalSpacing(6),
        Text(
          title,
          style: AppTextStyles.font14blackWeight600.copyWith(
            color: AppColorsManager.prescriptionTitleColor,
          ),
        ),
      ],
    );
  }
}

/// Asks before deleting a prescription row. True when confirmed.
Future<bool> confirmPrescriptionRowDelete(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final isConfirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text("إلغاء"),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(
            "حذف",
            style: TextStyle(color: AppColorsManager.prescriptionDeleteAction),
          ),
        ),
      ],
    ),
  );
  return isConfirmed == true;
}
