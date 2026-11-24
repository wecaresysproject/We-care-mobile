import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_profile_comment_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// "التعليقات" في ملف الطبيب: العنوان والعدد الإجمالي، ثم التعليقات المعروضة
/// (أول 3 من البروفايل)، و"المزيد" لتحميل صفحة إضافية طول ما فيه باقي.
class DoctorProfileCommentsSection extends StatelessWidget {
  const DoctorProfileCommentsSection({
    super.key,
    required this.comments,
    required this.totalCount,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  final List<DoctorProfileCommentModel> comments;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  static const _surface = Color(0xFFF2F7FE);
  static const _bubble = Color(0xFFE3EDFB);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: OnlineDoctorTheme.sectionBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                size: 20.sp,
                color: OnlineDoctorTheme.accentBlue,
              ),
              horizontalSpacing(6),
              Expanded(
                child: Text(
                  "التعليقات",
                  style: AppTextStyles.font16BlackSemiBold.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: OnlineDoctorTheme.headingColor,
                  ),
                ),
              ),
              Text(
                '$totalCount',
                style: AppTextStyles.font16BlackSemiBold.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: OnlineDoctorTheme.headingColor,
                ),
              ),
            ],
          ),
          verticalSpacing(10),
          for (var i = 0; i < comments.length; i++) ...[
            if (i != 0) verticalSpacing(8),
            _CommentBubble(comment: comments[i], color: _bubble),
          ],
          if (hasMore) ...[
            verticalSpacing(4),
            Center(
              child: isLoadingMore
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: OnlineDoctorTheme.accentBlue,
                        ),
                      ),
                    )
                  : TextButton.icon(
                      onPressed: onLoadMore,
                      iconAlignment: IconAlignment.end,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18.sp,
                        color: OnlineDoctorTheme.accentBlue,
                      ),
                      label: Text(
                        "المزيد",
                        style: AppTextStyles.font16BlackSemiBold.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: OnlineDoctorTheme.accentBlue,
                        ),
                      ),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CommentBubble extends StatelessWidget {
  const _CommentBubble({required this.comment, required this.color});

  final DoctorProfileCommentModel comment;
  final Color color;

  /// "18 نوفمبر 2026 - 08:11 مساءً"
  static String _dateTimeLabel(DateTime time) {
    final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour < 12 ? 'صباحاً' : 'مساءً';
    final clock = "${hour12.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}";
    return "${arabicShortDateLabel(time)} - $clock $period";
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = comment.createdAt;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8.w,
            children: [
              Text(
                comment.patientName.isEmpty ? "مريض" : comment.patientName,
                style: AppTextStyles.font16BlackSemiBold.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: OnlineDoctorTheme.headingColor,
                ),
              ),
              if (createdAt != null)
                Text(
                  _dateTimeLabel(createdAt),
                  style: AppTextStyles.font14blackWeight400.copyWith(
                    fontSize: 10.sp,
                    color: OnlineDoctorTheme.mutedText,
                  ),
                ),
            ],
          ),
          verticalSpacing(4),
          Text(
            comment.comment,
            style: AppTextStyles.font14blackWeight400.copyWith(
              fontSize: 11.sp,
              height: 1.7,
              color: OnlineDoctorTheme.sectionBodyText,
            ),
          ),
        ],
      ),
    );
  }
}
