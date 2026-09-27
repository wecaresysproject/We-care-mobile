import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/booking_settings/logic/cubit/booking_settings_cubit.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/booking_interval_card_widget.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/booking_settings_section_header_widget.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/weekday_schedule_row_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// Section 3 — "Weekly Booking Times": the per-day time-range list beside
/// the appointment-interval card.
class WeeklyBookingTimesSectionWidget extends StatelessWidget {
  const WeeklyBookingTimesSectionWidget({super.key});

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
          BookingSettingsSectionHeaderWidget(
            icon: Icons.event_available_outlined,
            title: localization.bookingSettingsFormWeeklyTimesTitle,
            stepNumber: 3,
            badgeBackgroundColor: AppColorsManager.basicDataSkyBadgeBackground,
            badgeIconColor: AppColorsManager.basicDataSkyBadgeIcon,
          ),
          verticalSpacing(4),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 30.w),
            child: Text(
              localization.bookingSettingsFormWeeklyTimesSubtitle,
              style: AppTextStyles.font13GreyWeight400,
            ),
          ),
          verticalSpacing(16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 560.w;
              final scheduleList = _WeekdayScheduleList();
              final intervalCard = const BookingIntervalCardWidget();

              if (!isWide) {
                return Column(
                  children: [
                    scheduleList,
                    verticalSpacing(16),
                    intervalCard,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: scheduleList),
                  horizontalSpacing(16),
                  Expanded(flex: 2, child: intervalCard),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WeekdayScheduleList extends StatelessWidget {
  const _WeekdayScheduleList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingSettingsCubit, BookingSettingsState>(
      buildWhen: (previous, current) =>
          previous.weeklySchedule != current.weeklySchedule,
      builder: (context, state) {
        return Column(
          children: [
            for (final schedule in state.weeklySchedule)
              WeekdayScheduleRowWidget(schedule: schedule),
          ],
        );
      },
    );
  }
}
