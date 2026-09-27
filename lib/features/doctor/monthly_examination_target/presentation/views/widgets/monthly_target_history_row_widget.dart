import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/monthly_examination_target/data/models/monthly_examination_target_model.dart';

/// One row of the monthly-target history table. RTL column order (as laid
/// out, right → left in Arabic): month name+year, goal, achieved,
/// completion % (with a horizontal bar colored green when on-track and
/// amber below the warning threshold), and a trailing expand chevron.
class MonthlyTargetHistoryRowWidget extends StatelessWidget {
  const MonthlyTargetHistoryRowWidget({super.key, required this.record});

  final MonthlyExaminationTargetModel record;

  /// Rows at or above this completion percentage read as on-track (green);
  /// below it they read as needing attention (amber).
  static const int _warningThreshold = 60;

  @override
  Widget build(BuildContext context) {
    final percentage = record.completionPercentage;
    final barColor = percentage >= _warningThreshold
        ? AppColorsManager.doneColor
        : AppColorsManager.basicDataAmberBadgeIcon;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColorsManager.placeHolderColor.withAlpha(40),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '${record.monthName} ${record.year}',
              style: AppTextStyles.font14blackWeight600,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${record.goalCount}',
              textAlign: TextAlign.center,
              style: AppTextStyles.font14GreyWeight400,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${record.achievedCount}',
              textAlign: TextAlign.center,
              style: AppTextStyles.font14blackWeight600,
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '$percentage%',
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyles.font12Weight600.copyWith(color: barColor),
                ),
                verticalSpacing(4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    minHeight: 6.h,
                    backgroundColor: AppColorsManager.shimmerBase,
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  ),
                ),
              ],
            ),
          ),
          horizontalSpacing(4),
          Icon(
            Icons.chevron_left,
            size: 18.r,
            color: AppColorsManager.placeHolderColor,
          ),
        ],
      ),
    );
  }
}
