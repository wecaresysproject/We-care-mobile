import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

class DoctorTimelineStatsWidget extends StatelessWidget {
  const DoctorTimelineStatsWidget({
    super.key,
    required this.waitingCount,
    required this.followUpsCount,
    required this.currentBookingsCount,
    required this.allowedBookingsCount,
  });

  final int waitingCount;
  final int followUpsCount;
  final int currentBookingsCount;
  final int allowedBookingsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColorsManager.homeSectionSurface,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: AppColorsManager.homeHeadingDarkBlue.withValues(
              alpha: 0.06,
            ),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _TimelineStatItem(
              iconAssetPath: 'assets/svgs/doctor_icon_waiting.svg',
              count: waitingCount,
              label: S.of(context).waitingLabel,
            ),
          ),
          const _TimelineDivider(),
          Expanded(
            child: _TimelineStatItem(
              iconAssetPath: 'assets/svgs/doctor_icon_followups.svg',
              count: followUpsCount,
              label: S.of(context).followUpsLabel,
            ),
          ),
          const _TimelineDivider(),
          Expanded(
            child: _TimelineStatItem(
              iconAssetPath: 'assets/svgs/doctor_icon_current_bookings.svg',
              count: currentBookingsCount,
              label:
                  '${S.of(context).currentBookingsLabelLine1} ${S.of(context).currentBookingsLabelLine2}',
            ),
          ),
          const _TimelineDivider(),
          Expanded(
            child: _TimelineStatItem(
              iconAssetPath: 'assets/svgs/doctor_icon_allowed_bookings.svg',
              count: allowedBookingsCount,
              label:
                  '${S.of(context).allowedBookingsLabelLine1} ${S.of(context).allowedBookingsLabelLine2}',
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
    return Container(
      width: 1,
      height: 54.h,
      color: AppColorsManager.homeDividerColor,
    );
  }
}

class _TimelineStatItem extends StatelessWidget {
  const _TimelineStatItem({
    required this.iconAssetPath,
    required this.count,
    required this.label,
  });

  final String iconAssetPath;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(iconAssetPath, width: 30.w, height: 28.h),
        SizedBox(height: 8.h),
        Text('$count', style: AppTextStyles.font20homeHeadingWeight700),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: AppTextStyles.font13homeLabelWeight500,
        ),
      ],
    );
  }
}
