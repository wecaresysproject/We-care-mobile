import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/home_section_title_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/monthly_examination_card_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// "الكشوفات الشهرية" card: the section title, then [examinationsContent]
/// (target/achieved cards) and [performanceContent] (views/shares/
/// appearances). The two slots come from separate APIs, so each one shows
/// its own shimmer/error inside the shared card.
class MonthlyExaminationsSectionWidget extends StatelessWidget {
  const MonthlyExaminationsSectionWidget({
    super.key,
    required this.examinationsContent,
    required this.performanceContent,
  });

  final Widget examinationsContent;
  final Widget performanceContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 16.h),
      decoration: BoxDecoration(
        color: AppColorsManager.homeSectionSurface,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColorsManager.homePrimaryBlue.withValues(alpha: 0.10),
            offset: const Offset(0, 6),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          HomeSectionTitleWidget(
            title: S.of(context).monthlyExaminationsSectionTitle,
            iconAssetPath: 'assets/svgs/doctor_icon_calendar_check.svg',
            fontSize: 18,
            iconSize: 24,
          ),
          verticalSpacing(14),
          examinationsContent,
          verticalSpacing(16),
          performanceContent,
        ],
      ),
    );
  }
}

/// Achieved (left) and target (right) cards side by side — physical order,
/// since the doctor home is forced LTR.
class MonthlyExaminationsCardsRowWidget extends StatelessWidget {
  const MonthlyExaminationsCardsRowWidget({
    super.key,
    required this.achievedExaminationsCount,
    required this.monthlyTargetExaminationsCount,
  });

  final int achievedExaminationsCount;
  final int monthlyTargetExaminationsCount;

  /// Share of this month's target already achieved, as a whole percent.
  int get _achievementRate => monthlyTargetExaminationsCount <= 0
      ? 0
      : (achievedExaminationsCount * 100 / monthlyTargetExaminationsCount)
          .round();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MonthlyAchievedCardWidget(
            title: S.of(context).achievedLabel,
            achievedCount: achievedExaminationsCount,
            targetCount: monthlyTargetExaminationsCount,
            achievementRate: _achievementRate,
          ),
          horizontalSpacing(10),
          MonthlyTargetCardWidget(
            targetCount: monthlyTargetExaminationsCount,
            label: S.of(context).monthlyTargetLabel,
          ),
        ],
      ),
    );
  }
}
