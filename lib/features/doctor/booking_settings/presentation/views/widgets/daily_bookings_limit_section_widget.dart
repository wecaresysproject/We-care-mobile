import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/booking_settings/logic/cubit/booking_settings_cubit.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/booking_settings_section_header_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// Section 1 — "Daily Bookings": the max-bookings-per-day picker.
class DailyBookingsLimitSectionWidget extends StatelessWidget {
  const DailyBookingsLimitSectionWidget({super.key});

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
            icon: Icons.groups_outlined,
            title: localization.bookingSettingsFormDailyLimitTitle,
            stepNumber: 1,
            badgeBackgroundColor: AppColorsManager.basicDataBlueBadgeBackground,
            badgeIconColor: AppColorsManager.basicDataBlueBadgeIcon,
          ),
          verticalSpacing(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.bookingSettingsFormDailyLimitLabel,
                      style: AppTextStyles.font14blackWeight600,
                    ),
                    verticalSpacing(4),
                    Text(
                      localization.bookingSettingsFormDailyLimitHint,
                      style: AppTextStyles.font13GreyWeight400,
                    ),
                  ],
                ),
              ),
              horizontalSpacing(12),
              BlocSelector<BookingSettingsCubit, BookingSettingsState, int>(
                selector: (state) => state.maxDailyBookings,
                builder: (context, maxDailyBookings) {
                  final unit = localization.bookingSettingsFormDailyLimitUnit;
                  return SizedBox(
                    width: 140.w,
                    child: UserSelectionContainer(
                      containerHintText: '$maxDailyBookings $unit',
                      initialValue: '$maxDailyBookings $unit',
                      options: [
                        for (final option
                            in BookingSettingsCubit.maxDailyBookingsOptions)
                          '$option $unit',
                      ],
                      bottomSheetTitle:
                          localization.bookingSettingsFormDailyLimitLabel,
                      searchHintText:
                          localization.bookingSettingsFormDailyLimitLabel,
                      onOptionSelected: (selected) {
                        final value = int.parse(selected.split(' ').first);
                        context
                            .read<BookingSettingsCubit>()
                            .updateMaxDailyBookings(value);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
