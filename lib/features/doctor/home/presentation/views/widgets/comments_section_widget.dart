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
        Row(
          children: [
            Expanded(
              child: Text(
                '$commentsCount',
                style: AppTextStyles.font18MainBlueWeight500,
              ),
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
        ),
        SizedBox(height: 8.h),
        for (final comment in comments) ...[
          CommentBubbleWidget(
            patientName: comment.patientName,
            comment: comment.comment,
          ),
          SizedBox(height: 8.h),
        ],
        Container(
          padding: EdgeInsets.only(bottom: 5.h),
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: AppColorsManager.mainDarkBlue, width: 1.5),
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
