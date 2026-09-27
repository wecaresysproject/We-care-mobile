import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/monthly_examination_target/logic/cubit/monthly_examination_target_cubit.dart';
import 'package:we_care/features/doctor/monthly_examination_target/presentation/views/widgets/monthly_goal_progress_ring_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// "الإنجاز الحالي" card: the progress ring on the leading side, and two
/// stacked stat blocks (achieved / monthly goal) on the trailing side.
class MonthlyGoalAchievementStatsWidget extends StatelessWidget {
  const MonthlyGoalAchievementStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColorsManager.basicDataTileBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColorsManager.placeHolderColor.withAlpha(60),
          width: 1.3,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.monthlyExaminationTargetFormCurrentAchievementTitle,
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(16),
          BlocSelector<MonthlyExaminationTargetCubit,
              MonthlyExaminationTargetState, (int, int, int)>(
            selector: (state) => (
              state.completionPercentage,
              state.achievedCount,
              state.selectedGoalCount,
            ),
            builder: (context, stats) {
              final (completionPercentage, achievedCount, goalCount) = stats;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MonthlyGoalProgressRingWidget(
                    percentage: completionPercentage,
                  ),
                  horizontalSpacing(20),
                  Expanded(
                    child: Column(
                      children: [
                        _StatBlock(
                          value: achievedCount,
                          caption: localization
                              .monthlyExaminationTargetFormAchievedCaption,
                          valueColor: AppColorsManager.achievedBadgeColor,
                        ),
                        verticalSpacing(12),
                        _StatBlock(
                          value: goalCount,
                          caption: localization
                              .monthlyExaminationTargetFormGoalCaption,
                          valueColor: AppColorsManager.monthlyTargetBadgeColor,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// A single "big number + caption" stat block, tightly coupled to
/// [MonthlyGoalAchievementStatsWidget]'s stacked-stats layout — not a
/// standalone reusable widget, so it stays private to this file.
class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.value,
    required this.caption,
    required this.valueColor,
  });

  final int value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColorsManager.placeHolderColor.withAlpha(40),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style:
                AppTextStyles.font20blackWeight700.copyWith(color: valueColor),
          ),
          verticalSpacing(2),
          Text(
            caption,
            style: AppTextStyles.font13GreyWeight400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
