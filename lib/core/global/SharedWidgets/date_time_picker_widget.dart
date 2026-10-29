import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Custom Date Formatter for DD/MM/YYYY

class DateTimePickerContainer extends StatefulWidget {
  final String placeholderText;
  final Function(String)? onDateSelected;
  final Color containerBorderColor;
  final bool? isForInsuranceExpiry;

  /// Earliest selectable date. Defaults to 1900 when not set.
  final DateTime? firstDate;

  /// Pre-selected date, e.g. a value loaded from the server for editing.
  final DateTime? initialDate;

  /// How the selected date is shown in the field. Defaults to `yyyy-MM-dd`;
  /// pass `yyyy` for year-only fields. The value sent to [onDateSelected] is
  /// always `yyyy-MM-dd`.
  final String? displayPattern;

  const DateTimePickerContainer({
    super.key,
    required this.placeholderText,
    this.onDateSelected,
    this.containerBorderColor = AppColorsManager.textfieldOutsideBorderColor,
    this.isForInsuranceExpiry = false,
    this.firstDate,
    this.initialDate,
    this.displayPattern,
  });

  @override
  DatePickerContainerState createState() => DatePickerContainerState();
}

class DatePickerContainerState extends State<DateTimePickerContainer> {
  DateTime? selectedDate;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd', 'en');

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(covariant DateTimePickerContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate &&
        widget.initialDate != null) {
      selectedDate = widget.initialDate;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final firstSelectableDate = widget.firstDate ?? DateTime(1900);
    final lastSelectableDate = widget.isForInsuranceExpiry!
        ? DateTime.now().add(const Duration(days: 3650)) // 10 سنوات لقدام
        : DateTime.now();
    // A saved date loaded from the server can fall outside the selectable
    // range; showDatePicker asserts on that, so start from the nearest edge.
    var initialPickerDate = selectedDate ?? DateTime.now();
    if (initialPickerDate.isBefore(firstSelectableDate)) {
      initialPickerDate = firstSelectableDate;
    } else if (initialPickerDate.isAfter(lastSelectableDate)) {
      initialPickerDate = lastSelectableDate;
    }
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialPickerDate,
      firstDate: firstSelectableDate,
      lastDate: lastSelectableDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            hintColor: Colors.blue, // Selected text color
            colorScheme: ColorScheme.light(
              primary: AppColorsManager.mainDarkBlue,
            ),

            dividerTheme: DividerThemeData(
              color: Colors.grey, // Divider color
              thickness: .5,
            ),

            textTheme: TextTheme(
              titleLarge: AppTextStyles.font22MainBlueWeight700,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    AppColorsManager.mainDarkBlue, // Button text color
                textStyle: AppTextStyles.font12blackWeight400,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // Call the callback function with the selected date
      if (widget.onDateSelected != null) {
        //! trim the date from 2025-02-10 00:00:00.000 to 2025-02-10
        String formattedDate = dateFormat.format(picked);

        widget.onDateSelected!(formattedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r), // Border radius
              border: Border.all(
                color: widget.containerBorderColor,
                width: 0.8,
              ), // Border color & thickness
              color: AppColorsManager.textfieldInsideColor.withAlpha(100),
            ),
            alignment:
                !isArabic() ? Alignment.centerLeft : Alignment.centerRight,
            child: Text(
              selectedDate == null
                  ? widget.placeholderText
                  : DateFormat(widget.displayPattern ?? 'yyyy-MM-dd', 'en')
                      .format(selectedDate!),
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: selectedDate != null //TODO: !check it later
                    ? AppColorsManager.textColor
                    : AppColorsManager.placeHolderColor,
                // color: AppColorsManager.placeHolderColor,
              ),
            ),
          ),
          if (widget.containerBorderColor ==
              AppColorsManager
                  .warningColor) // Show error message if required and not selected
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Text(
                context.translate.required_field,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            ),
        ],
      ),
    );
  }
}
