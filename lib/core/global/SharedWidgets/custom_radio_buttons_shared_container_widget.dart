//used in data entry views

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomToggleRadioContainer extends StatefulWidget {
  final String title;
  final String option1;
  final String option2;
  final ValueChanged<String> onChanged;
  final String initialValue;

  const CustomToggleRadioContainer({
    super.key,
    required this.title,
    required this.option1,
    required this.option2,
    required this.onChanged,
    required this.initialValue,
  });

  @override
  CustomToggleRadioContainerState createState() =>
      CustomToggleRadioContainerState();
}

class CustomToggleRadioContainerState
    extends State<CustomToggleRadioContainer> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  void _onOptionSelected(String value) {
    setState(() {
      selectedValue = value;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(12),
        Container(
          width: double.infinity,
          height: 44.h,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ), // Left & Right Padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColorsManager
                  .textfieldOutsideBorderColor, // Change border if error
              width: 0.8,
            ),
            color: AppColorsManager.textfieldInsideColor.withAlpha(100),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOption(widget.option1),
              _buildOption(widget.option2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOption(String value) {
    final bool isSelected = selectedValue == value;
    return GestureDetector(
      onTap: () => _onOptionSelected(value),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColorsManager.mainDarkBlue
                    : AppColorsManager.placeHolderColor,
                width: 3,
              ),
            ),
            child: isSelected
                ? const Center(
                    child: Icon(
                      Icons.circle,
                      size: 18,
                      color: AppColorsManager.mainDarkBlue,
                    ),
                  )
                : null,
          ),
          horizontalSpacing(5),
          Text(
            value,
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
