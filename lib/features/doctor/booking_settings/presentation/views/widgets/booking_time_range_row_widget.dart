import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/time_range_model.dart';

/// One "10:00 AM – 1:00 PM" pill inside a weekday's expanded time-ranges
/// list, with a trailing remove button.
class BookingTimeRangeRowWidget extends StatelessWidget {
  const BookingTimeRangeRowWidget({
    super.key,
    required this.timeRange,
    required this.onRemove,
  });

  final TimeRangeModel timeRange;
  final VoidCallback onRemove;

  String _formatTimeOfDay(String value) {
    final parts = value.split(':');
    final hour24 = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour24 >= 12 ? 'م' : 'ص';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    return '$hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColorsManager.textfieldInsideColor.withAlpha(100),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColorsManager.placeHolderColor.withAlpha(50),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_formatTimeOfDay(timeRange.startTime)} - '
            '${_formatTimeOfDay(timeRange.endTime)}',
            style: AppTextStyles.font12Weight600,
          ),
          horizontalSpacing(6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14.r,
              color: AppColorsManager.placeHolderColor,
            ),
          ),
        ],
      ),
    );
  }
}
