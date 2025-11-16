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

  const DateTimePickerContainer({
    super.key,
    required this.placeholderText,
    this.onDateSelected,
    this.containerBorderColor = AppColorsManager.textfieldOutsideBorderColor,
    this.isForInsuranceExpiry = false,
  });

  @override
  DatePickerContainerState createState() => DatePickerContainerState();
}

class DatePickerContainerState extends State<DateTimePickerContainer> {
  DateTime? selectedDate;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd', 'en');

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: widget.isForInsuranceExpiry!
          ? DateTime.now().add(const Duration(days: 3650)) // 10 سنوات لقدام
          : DateTime.now(),
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
                  : dateFormat.format(selectedDate!),
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
