import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// The value box shared by the "Daily Bookings" and "Appointment Interval"
/// sections: a picker while the doctor sets the value by hand, or a locked
/// box showing the calculated value otherwise.
class BookingValueFieldWidget extends StatelessWidget {
  const BookingValueFieldWidget({
    super.key,
    required this.isManual,
    required this.value,
    required this.unit,
    required this.options,
    required this.bottomSheetTitle,
    required this.onSelected,
  });

  final bool isManual;

  /// `null` when the value is calculated but can't be worked out yet.
  final int? value;
  final String unit;
  final List<int> options;
  final String bottomSheetTitle;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (isManual) {
      final selected = '$value $unit';
      return UserSelectionContainer(
        containerHintText: selected,
        initialValue: selected,
        options: [for (final option in options) '$option $unit'],
        bottomSheetTitle: bottomSheetTitle,
        searchHintText: bottomSheetTitle,
        onOptionSelected: (selected) =>
            onSelected(int.parse(selected.split(' ').first)),
      );
    }

    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColorsManager.placeHolderColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColorsManager.placeHolderColor.withAlpha(60),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value == null ? '—' : '$value $unit',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font16DarkGreyWeight400,
            ),
          ),
          Icon(
            Icons.lock_outline,
            size: 18.r,
            color: AppColorsManager.placeHolderColor,
          ),
        ],
      ),
    );
  }
}

/// Shown under a locked [BookingValueFieldWidget]: explains the value is
/// calculated (or can't be yet) and lets the doctor take it over by hand.
class BookingCalculatedNoteWidget extends StatelessWidget {
  const BookingCalculatedNoteWidget({
    super.key,
    required this.hasValue,
    required this.onSetManually,
  });

  final bool hasValue;
  final VoidCallback onSetManually;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.auto_awesome_outlined,
          size: 16.r,
          color: AppColorsManager.mainDarkBlue,
        ),
        horizontalSpacing(6),
        Expanded(
          child: Text(
            hasValue
                ? 'تُحسب تلقائيًا من أيام وتوقيتات الحجز'
                : 'أضف أيام وتوقيتات حجز كافية لحساب هذه القيمة',
            style: AppTextStyles.font13GreyWeight400,
          ),
        ),
        TextButton(
          onPressed: onSetManually,
          child: Text(
            'تحديد يدويًا',
            style: AppTextStyles.font14blackWeight600.copyWith(
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
        ),
      ],
    );
  }
}
