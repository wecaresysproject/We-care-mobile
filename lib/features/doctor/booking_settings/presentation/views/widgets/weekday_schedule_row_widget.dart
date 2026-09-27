import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/time_range_model.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/weekday_schedule_model.dart';
import 'package:we_care/features/doctor/booking_settings/logic/cubit/booking_settings_cubit.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/booking_time_range_row_widget.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/weekday_label.dart';
import 'package:we_care/generated/l10n.dart';

/// One weekday row inside the "Weekly Booking Times" list: a day
/// name/calendar icon trailing edge, an "add time range" action, and every
/// configured time range for that day shown inline (or "Not available").
class WeekdayScheduleRowWidget extends StatelessWidget {
  const WeekdayScheduleRowWidget({super.key, required this.schedule});

  final WeekdayScheduleModel schedule;

  Future<void> _pickTimeRange(BuildContext context) async {
    final localization = S.of(context);
    final cubit = context.read<BookingSettingsCubit>();

    final start = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      helpText: localization.bookingSettingsFormStartTimeSheetTitle,
    );
    if (start == null || !context.mounted) return;

    final end = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 13, minute: 0),
      helpText: localization.bookingSettingsFormEndTimeSheetTitle,
    );
    if (end == null) return;

    String formatted(TimeOfDay time) =>
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';

    cubit.addTimeRange(
      schedule.day,
      TimeRangeModel(startTime: formatted(start), endTime: formatted(end)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColorsManager.textfieldInsideColor.withAlpha(100),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColorsManager.placeHolderColor.withAlpha(50),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 16.r,
            color: AppColorsManager.mainDarkBlue,
          ),
          horizontalSpacing(4),
          SizedBox(
            width: 62.w,
            child: Text(
              weekdayLabel(context, schedule.day),
              style: AppTextStyles.font14blackWeight600,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          horizontalSpacing(6),
          GestureDetector(
            onTap: () => _pickTimeRange(context),
            child: Icon(
              Icons.add_circle_outline,
              size: 20.r,
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
          horizontalSpacing(6),
          Expanded(
            child: schedule.timeRanges.isEmpty
                ? Text(
                    localization.bookingSettingsFormNotAvailable,
                    style: AppTextStyles.font14blackWeight600.copyWith(
                      color: AppColorsManager.placeHolderColor,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: [
                      for (var i = 0; i < schedule.timeRanges.length; i++)
                        BookingTimeRangeRowWidget(
                          timeRange: schedule.timeRanges[i],
                          onRemove: () => context
                              .read<BookingSettingsCubit>()
                              .removeTimeRange(schedule.day, i),
                        ),
                    ],
                  ),
          ),
          horizontalSpacing(4),
          Icon(
            Icons.keyboard_arrow_down,
            size: 20.r,
            color: AppColorsManager.placeHolderColor,
          ),
        ],
      ),
    );
  }
}
