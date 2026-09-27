import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// One weekday cell in the "Weekly Booking Days" grid: a day label above a
/// blue on/off switch.
class BookingDaySwitchWidget extends StatelessWidget {
  const BookingDaySwitchWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.font14blackWeight600,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        verticalSpacing(10),
        Transform.scale(
          scale: 0.85,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColorsManager.mainDarkBlue,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColorsManager.placeHolderColor.withAlpha(
              90,
            ),
            trackOutlineColor: const WidgetStatePropertyAll(
              Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
