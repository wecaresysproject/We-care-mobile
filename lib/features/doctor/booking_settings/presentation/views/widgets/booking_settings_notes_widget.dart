import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/booking_settings_section_header_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// Section 4 — "Notes": the closing info box explaining how these settings
/// are used.
class BookingSettingsNotesWidget extends StatelessWidget {
  const BookingSettingsNotesWidget({super.key});

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
            icon: Icons.lightbulb_outline,
            title: localization.bookingSettingsFormNotesTitle,
            stepNumber: 4,
            badgeBackgroundColor:
                AppColorsManager.basicDataAmberBadgeBackground,
            badgeIconColor: AppColorsManager.basicDataAmberBadgeIcon,
          ),
          verticalSpacing(12),
          Text(
            localization.bookingSettingsFormNoteUsage,
            style: AppTextStyles.font14blackWeight400,
          ),
        ],
      ),
    );
  }
}
