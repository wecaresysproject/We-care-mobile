import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_performance_stats_model.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/performance_stat_card_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// Laid out in physical left-to-right order (the doctor home is forced
/// LTR): مرات الظهور, المشاركات, المشاهدات.
class PerformanceStatsRowWidget extends StatelessWidget {
  const PerformanceStatsRowWidget({
    super.key,
    required this.stats,
  });

  final DoctorPerformanceStatsModel stats;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PerformanceStatCardWidget(
            title: S.of(context).appearancesLabel,
            iconAssetPath: 'assets/svgs/doctor_icon_user_search.svg',
            monthlyCount: stats.appearances.last30Days,
            yearlyCount: stats.appearances.last12Months,
          ),
          horizontalSpacing(8),
          PerformanceStatCardWidget(
            title: S.of(context).sharesLabel,
            iconAssetPath: 'assets/svgs/doctor_icon_perf_share.svg',
            monthlyCount: stats.shares.last30Days,
            yearlyCount: stats.shares.last12Months,
          ),
          horizontalSpacing(8),
          PerformanceStatCardWidget(
            title: S.of(context).watchesLabel,
            iconAssetPath: 'assets/svgs/doctor_icon_perf_eye.svg',
            monthlyCount: stats.views.last30Days,
            yearlyCount: stats.views.last12Months,
          ),
        ],
      ),
    );
  }
}
