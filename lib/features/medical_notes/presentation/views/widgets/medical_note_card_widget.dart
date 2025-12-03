import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_notes/data/models/medical_note_model.dart';

class MedicalNoteCardWidget extends StatelessWidget {
  final MedicalNote note;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;

  const MedicalNoteCardWidget({
    super.key,
    required this.note,
    required this.isSelectionMode,
    required this.onTap,
    this.onDoubleTap,
  });

  String _formatDate(BuildContext context, DateTime date) {
    // Format date as "12 / 5 / 2025" to match design
    return '${date.day} / ${date.month} / ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Color(0xFFF1F3F6),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: note.isSelected!
                ? AppColorsManager.warningColor
                : Colors.transparent,
            width: note.isSelected! ? 2.0 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox shown only in selection mode
            if (isSelectionMode) ...[
              Container(
                width: 24.w,
                height: 24.h,
                margin: EdgeInsets.only(left: 12.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: note.isSelected!
                      ? AppColorsManager.mainDarkBlue
                      : Colors.transparent,
                  border: Border.all(
                    color: note.isSelected!
                        ? AppColorsManager.mainDarkBlue
                        : AppColorsManager.textColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: note.isSelected!
                    ? Icon(
                        Icons.check,
                        size: 16.sp,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  Text(
                    _formatDate(context, note.date),
                    style: AppTextStyles.font14whiteWeight600.copyWith(
                      color: AppColorsManager.textColor.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  verticalSpacing(8),

                  // Note content preview
                  Text(
                    note.note,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      color: AppColorsManager.textColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
