import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/booking_settings/logic/cubit/booking_settings_cubit.dart';
import 'package:we_care/generated/l10n.dart';

/// The appointment-interval card beside the weekly time-slots list.
class BookingIntervalCardWidget extends StatelessWidget {
  const BookingIntervalCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColorsManager.basicDataScaffoldBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: const BoxDecoration(
              color: AppColorsManager.basicDataBlueBadgeBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_rounded,
              size: 20.r,
              color: AppColorsManager.basicDataBlueBadgeIcon,
            ),
          ),
          verticalSpacing(10),
          Text(
            localization.bookingSettingsFormIntervalTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14blackWeight600,
          ),
          verticalSpacing(6),
          Text(
            localization.bookingSettingsFormIntervalSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.font13GreyWeight400,
          ),
          verticalSpacing(14),
          BlocSelector<BookingSettingsCubit, BookingSettingsState, int>(
            selector: (state) => state.intervalMinutes,
            builder: (context, intervalMinutes) {
              final unit = localization.bookingSettingsFormIntervalUnit;
              return UserSelectionContainer(
                containerHintText: '$intervalMinutes $unit',
                initialValue: '$intervalMinutes $unit',
                options: [
                  for (final option
                      in BookingSettingsCubit.intervalMinutesOptions)
                    '$option $unit',
                ],
                bottomSheetTitle: localization.bookingSettingsFormIntervalTitle,
                searchHintText: localization.bookingSettingsFormIntervalTitle,
                onOptionSelected: (selected) {
                  final value = int.parse(selected.split(' ').first);
                  context
                      .read<BookingSettingsCubit>()
                      .updateIntervalMinutes(value);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
