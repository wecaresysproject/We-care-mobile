import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/booking_value_source.dart';
import 'package:we_care/features/doctor/booking_settings/logic/cubit/booking_settings_cubit.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/booking_settings_section_header_widget.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/booking_value_field_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// Section 2 — "Appointment Interval": picked by hand, or calculated from
/// the daily limit and the weekly days/times (see [BookingValueSource]).
class BookingIntervalSectionWidget extends StatelessWidget {
  const BookingIntervalSectionWidget({super.key});

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
            icon: Icons.access_time_rounded,
            title: localization.bookingSettingsFormIntervalTitle,
            stepNumber: 2,
            badgeBackgroundColor: AppColorsManager.basicDataBlueBadgeBackground,
            badgeIconColor: AppColorsManager.basicDataBlueBadgeIcon,
          ),
          verticalSpacing(16),
          BlocBuilder<BookingSettingsCubit, BookingSettingsState>(
            buildWhen: (prev, curr) =>
                prev.valueSource != curr.valueSource ||
                prev.effectiveIntervalMinutes != curr.effectiveIntervalMinutes,
            builder: (context, state) {
              final cubit = context.read<BookingSettingsCubit>();
              final isManual = state.valueSource == BookingValueSource.interval;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'مدة الموعد الواحد',
                          style: AppTextStyles.font14blackWeight600,
                        ),
                      ),
                      horizontalSpacing(12),
                      SizedBox(
                        width: 140.w,
                        child: BookingValueFieldWidget(
                          isManual: isManual,
                          value: state.effectiveIntervalMinutes,
                          unit: localization.bookingSettingsFormIntervalUnit,
                          options: BookingSettingsCubit.intervalMinutesOptions,
                          bottomSheetTitle:
                              localization.bookingSettingsFormIntervalTitle,
                          onSelected: cubit.updateIntervalMinutes,
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing(8),
                  Text(
                    localization.bookingSettingsFormIntervalSubtitle,
                    style: AppTextStyles.font13GreyWeight400,
                  ),
                  if (!isManual) ...[
                    verticalSpacing(4),
                    BookingCalculatedNoteWidget(
                      hasValue: state.effectiveIntervalMinutes != null,
                      onSetManually: () =>
                          cubit.selectValueSource(BookingValueSource.interval),
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
