import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_performance_metric_model.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/performance_stat_card_widget.dart';
import 'package:we_care/generated/l10n.dart';

class PerformanceStatsRowWidget extends StatelessWidget {
  const PerformanceStatsRowWidget({
    super.key,
    required this.appearances,
    required this.shares,
    required this.watches,
  });

  final DoctorPerformanceMetricModel appearances;
  final DoctorPerformanceMetricModel shares;
  final DoctorPerformanceMetricModel watches;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PerformanceStatCardWidget(
          title: S.of(context).appearancesLabel,
          iconAssetPath: 'assets/svgs/doctor_icon_views_counter.svg',
          gradientColors: AppColorsManager.homeAppearancesCardGradient,
          metricTextColor: AppColorsManager.homeAppearancesCardMetricText,
          monthlyCount: appearances.monthlyCount,
          yearlyCount: appearances.yearlyCount,
        ),
        SizedBox(width: 14.w),
        PerformanceStatCardWidget(
          title: S.of(context).sharesLabel,
          iconAssetPath: 'assets/svgs/doctor_icon_shares.svg',
          gradientColors: AppColorsManager.homeSharesCardGradient,
          metricTextColor: AppColorsManager.homeSharesCardMetricText,
          monthlyCount: shares.monthlyCount,
          yearlyCount: shares.yearlyCount,
        ),
        SizedBox(width: 14.w),
        PerformanceStatCardWidget(
          title: S.of(context).watchesLabel,
          iconAssetPath: 'assets/svgs/doctor_icon_watch_eye.svg',
          gradientColors: AppColorsManager.homeViewsCardGradient,
          metricTextColor: AppColorsManager.homeViewsCardMetricText,
          monthlyCount: watches.monthlyCount,
          yearlyCount: watches.yearlyCount,
        ),
      ],
    );
  }
}
