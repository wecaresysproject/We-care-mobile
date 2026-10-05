import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/weekday.dart';
import 'package:we_care/features/doctor/booking_settings/logic/cubit/booking_settings_cubit.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/booking_day_switch_widget.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/booking_settings_section_header_widget.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/weekday_label.dart';
import 'package:we_care/generated/l10n.dart';

/// Section 3 — "Weekly Booking Days": one switch per weekday.
class WeeklyBookingDaysSectionWidget extends StatelessWidget {
  const WeeklyBookingDaysSectionWidget({super.key});

  static const _daysPerRow = 4;

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
            icon: Icons.event_note_outlined,
            title: localization.bookingSettingsFormWeeklyDaysTitle,
            stepNumber: 3,
            badgeBackgroundColor: AppColorsManager.basicDataSkyBadgeBackground,
            badgeIconColor: AppColorsManager.basicDataSkyBadgeIcon,
          ),
          verticalSpacing(4),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 30.w),
            child: Text(
              localization.bookingSettingsFormWeeklyDaysSubtitle,
              style: AppTextStyles.font13GreyWeight400,
            ),
          ),
          verticalSpacing(16),
          BlocSelector<BookingSettingsCubit, BookingSettingsState,
              Map<Weekday, bool>>(
            selector: (state) => {
              for (final schedule in state.weeklySchedule)
                schedule.day: schedule.isEnabled,
            },
            builder: (context, enabledByDay) {
              final days = Weekday.values;
              return Column(
                children: [
                  for (var start = 0;
                      start < days.length;
                      start += _daysPerRow) ...[
                    if (start > 0) verticalSpacing(16),
                    // spaceEvenly: equal gaps between days and at both
                    // edges, computed per row regardless of its day count.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (final day in days.skip(start).take(_daysPerRow))
                          BookingDaySwitchWidget(
                            label: weekdayLabel(context, day),
                            value: enabledByDay[day] ?? false,
                            onChanged: (_) => context
                                .read<BookingSettingsCubit>()
                                .toggleDayEnabled(day),
                          ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
