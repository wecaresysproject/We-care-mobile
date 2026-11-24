import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/home_section_title_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// "حجوزات اليوم" card: four counters (waiting, follow-ups, bookings,
/// allowed limit), each with a glossy illustration icon, a big
/// count and a label, separated by thin vertical dividers.
class DoctorTimelineStatsWidget extends StatelessWidget {
  const DoctorTimelineStatsWidget({
    super.key,
    required this.waitingCount,
    required this.followUpsCount,
    required this.currentBookingsCount,
    required this.allowedBookingsCount,
    this.onBookingsTap,
    this.onFollowUpsTap,
    this.onWaitingTap,
  });

  final int waitingCount;
  final int followUpsCount;
  final int currentBookingsCount;
  final int allowedBookingsCount;

  /// Tapping the "الحجوزات" counter (opens today's appointments).
  final VoidCallback? onBookingsTap;

  /// Tapping the "المتابعات" counter (opens today's follow-ups).
  final VoidCallback? onFollowUpsTap;

  /// Tapping the "الانتظار" counter (opens the waiting list).
  final VoidCallback? onWaitingTap;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 12.h),
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
          const HomeSectionTitleWidget(
            title: 'حجوزات اليوم',
            iconAssetPath: 'assets/svgs/doctor_icon_calendar_check.svg',
            fontSize: 18,
            iconSize: 24,
          ),
          verticalSpacing(8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _TimelineStatItem(
                    iconAssetPath: 'assets/images/doctor_daily_waiting.png',
                    count: waitingCount,
                    label: s.waitingLabel,
                    onTap: onWaitingTap,
                  ),
                ),
                const _TimelineDivider(),
                Expanded(
                  child: _TimelineStatItem(
                    iconAssetPath: 'assets/images/doctor_daily_followups.png',
                    count: followUpsCount,
                    label: s.followUpsLabel,
                    onTap: onFollowUpsTap,
                  ),
                ),
                const _TimelineDivider(),
                Expanded(
                  child: _TimelineStatItem(
                    iconAssetPath:
                        'assets/images/doctor_daily_current_bookings.png',
                    count: currentBookingsCount,
                    label: 'الحجوزات',
                    onTap: onBookingsTap,
                  ),
                ),
                const _TimelineDivider(),
                Expanded(
                  child: _TimelineStatItem(
                    iconAssetPath:
                        'assets/images/doctor_daily_allowed_bookings.png',
                    count: allowedBookingsCount,
                    label: 'الحد المسموح',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineDivider extends StatelessWidget {
  const _TimelineDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        width: 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          color: AppColorsManager.homeDividerColor,
        ),
      ),
    );
  }
}

class _TimelineStatItem extends StatelessWidget {
  const _TimelineStatItem({
    required this.iconAssetPath,
    required this.count,
    required this.label,
    this.onTap,
  });

  final String iconAssetPath;
  final int count;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          iconAssetPath,
          width: 42.w,
          height: 42.w,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
        verticalSpacing(4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$count',
            maxLines: 1,
            style: AppTextStyles.font22homeHeadingWeight700.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: AppTextStyles.font13homeLabelWeight500.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: content,
      ),
    );
  }
}
