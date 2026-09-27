import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/monthly_examination_target/logic/cubit/monthly_examination_target_cubit.dart';
import 'package:we_care/features/doctor/monthly_examination_target/presentation/views/widgets/monthly_target_history_row_widget.dart';
import 'package:we_care/features/doctor/shared/widgets/app_shimmer.dart';
import 'package:we_care/generated/l10n.dart';

/// "سجل المستهدفات الشهرية" card: a chart/bars icon badge + title header,
/// a column-header row, and the history rows. Renders an [AppShimmer]
/// skeleton while loading and reuses the shared error view on failure.
class MonthlyTargetHistorySectionWidget extends StatelessWidget {
  const MonthlyTargetHistorySectionWidget({super.key});

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
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColorsManager.basicDataSkyBadgeBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 18.r,
                  color: AppColorsManager.basicDataSkyBadgeIcon,
                ),
              ),
              horizontalSpacing(8),
              Expanded(
                child: Text(
                  localization.monthlyExaminationTargetFormHistoryTitle,
                  style: AppTextStyles.font18blackWight500,
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          BlocBuilder<MonthlyExaminationTargetCubit,
              MonthlyExaminationTargetState>(
            buildWhen: (prev, curr) =>
                prev.loadingStatus != curr.loadingStatus ||
                prev.history != curr.history,
            builder: (context, state) {
              switch (state.loadingStatus) {
                case RequestStatus.loading:
                case RequestStatus.initial:
                  return const _HistorySkeleton();
                case RequestStatus.failure:
                  return _HistoryError(message: state.message);
                case RequestStatus.success:
                  if (state.history.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      _HistoryHeaderRow(localization: localization),
                      for (final record in state.history)
                        MonthlyTargetHistoryRowWidget(record: record),
                    ],
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _HistoryHeaderRow extends StatelessWidget {
  const _HistoryHeaderRow({required this.localization});

  final S localization;

  @override
  Widget build(BuildContext context) {
    final headerStyle = AppTextStyles.font12blackWeight500
        .copyWith(color: AppColorsManager.placeHolderColor);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              localization.monthlyExaminationTargetFormHistoryColumnMonth,
              style: headerStyle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              localization.monthlyExaminationTargetFormHistoryColumnGoal,
              textAlign: TextAlign.center,
              style: headerStyle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              localization.monthlyExaminationTargetFormHistoryColumnAchieved,
              textAlign: TextAlign.center,
              style: headerStyle,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              localization.monthlyExaminationTargetFormHistoryColumnCompletion,
              textAlign: TextAlign.center,
              style: headerStyle,
            ),
          ),
          horizontalSpacing(22),
        ],
      ),
    );
  }
}

class _HistorySkeleton extends StatelessWidget {
  const _HistorySkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: [
          for (int i = 0; i < 4; i++) ...[
            Row(
              children: [
                AppShimmerBone(width: 80.w, height: 14.h),
                horizontalSpacing(16),
                AppShimmerBone(width: 30.w, height: 14.h),
                horizontalSpacing(16),
                AppShimmerBone(width: 30.w, height: 14.h),
                horizontalSpacing(16),
                Expanded(
                    child:
                        AppShimmerBone(width: double.infinity, height: 14.h)),
              ],
            ),
            verticalSpacing(16),
          ],
        ],
      ),
    );
  }
}

class _HistoryError extends StatelessWidget {
  const _HistoryError({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: AppColorsManager.warningColor,
              size: 32.r,
            ),
            verticalSpacing(8),
            Text(
              message ?? '',
              textAlign: TextAlign.center,
              style: AppTextStyles.font13GreyWeight400,
            ),
            verticalSpacing(12),
            TextButton(
              onPressed: () => context
                  .read<MonthlyExaminationTargetCubit>()
                  .loadMonthlyTargetData(),
              child: Text(
                S.of(context).monthlyExaminationTargetFormRetry,
                style: AppTextStyles.font14blackWeight600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
