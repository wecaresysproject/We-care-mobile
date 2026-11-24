import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_comment_model.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/comment_bubble_widget.dart';
import 'package:we_care/generated/l10n.dart';

class CommentsSectionWidget extends StatelessWidget {
  const CommentsSectionWidget({
    super.key,
    required this.commentsCount,
    required this.comments,
  });

  final int commentsCount;
  final List<DoctorCommentModel> comments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentsHeaderWidget(commentsCount: commentsCount),
        SizedBox(height: 8.h),
        if (comments.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Center(
              child: Text(
                'لا توجد تعليقات بعد',
                style: AppTextStyles.font14GreyWeight400,
              ),
            ),
          ),
        for (final comment in comments) ...[
          CommentBubbleWidget(
            patientName: comment.patientName,
            comment: comment.comment,
            createdAt: comment.createdAt,
          ),
          SizedBox(height: 8.h),
        ],
        // القايمة الكاملة لسه ملهاش endpoint — بيظهر بس لو فيه تعليقات أكتر
        // من اللى معروضة.
        if (commentsCount > comments.length)
          Container(
            padding: EdgeInsets.only(bottom: 5.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColorsManager.mainDarkBlue,
                  width: 1.5,
                ),
              ),
            ),
            child: Text(
              S.of(context).viewMore,
              style: AppTextStyles.font16MainBlueWeight600,
            ),
          ),
      ],
    );
  }
}

/// "التعليقات" title row; the count is omitted when unknown (e.g. on error).
class CommentsHeaderWidget extends StatelessWidget {
  const CommentsHeaderWidget({super.key, this.commentsCount});

  final int? commentsCount;

  @override
  Widget build(BuildContext context) {
    final count = commentsCount;
    return Row(
      children: [
        Expanded(
          child: count == null
              ? const SizedBox.shrink()
              : Text('$count', style: AppTextStyles.font18MainBlueWeight500),
        ),
        Text(
          S.of(context).commentsTitle,
          style: AppTextStyles.font18MainBlueWeight500,
        ),
        SizedBox(width: 8.w),
        SvgPicture.asset(
          'assets/svgs/doctor_icon_comments_edit.svg',
          width: 24.w,
          height: 24.h,
        ),
      ],
    );
  }
}
