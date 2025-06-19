import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class TrueOrFalseWithQuestionWidget extends StatefulWidget {
  final String question;
  final String imagePath;
  final Color containerValidationColor;
  final String? initialOption; // Add this parameter
  final Function(String) onOptionSelected;

  const TrueOrFalseWithQuestionWidget({
    super.key,
    required this.question,
    required this.imagePath,
    this.containerValidationColor = AppColorsManager.babyBlueColor,
    this.initialOption, // Make it optional
    required this.onOptionSelected,
  });

  @override
  TrueOrFalseWithQuestionWidgetState createState() =>
      TrueOrFalseWithQuestionWidgetState();
}

class TrueOrFalseWithQuestionWidgetState
    extends State<TrueOrFalseWithQuestionWidget> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _initializeSelectedOption();
  }

  @override
  void didUpdateWidget(TrueOrFalseWithQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialOption != oldWidget.initialOption) {
      _initializeSelectedOption();
    }
  }

  void _initializeSelectedOption() {
    if (widget.initialOption != _selectedOption) {
      setState(() {
        _selectedOption = widget.initialOption;
      });
      if (_selectedOption != null) {
        widget.onOptionSelected(_selectedOption!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(8, 8, 16, 0.h),
          decoration: BoxDecoration(
            color: widget.containerValidationColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    widget.imagePath,
                    width: 24.w,
                    height: 24.h,
                  ),
                  horizontalSpacing(7),
                  Expanded(
                    child: Text(
                      widget.question,
                      style: AppTextStyles.font18blackWight500,
                    ),
                  ),
                ],
              ),
              verticalSpacing(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 1.4,
                    child: Radio<String>(
                      value: "نعم",
                      groupValue: _selectedOption,
                      activeColor: AppColorsManager.mainDarkBlue,
                      visualDensity:
                          VisualDensity(horizontal: -2, vertical: -2),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                        widget.onOptionSelected(value!);
                      },
                    ),
                  ),
                  Text(
                    "نعم",
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      color: AppColorsManager.textColor,
                    ),
                  ),
                  horizontalSpacing(16),
                  Transform.scale(
                    scale: 1.4,
                    child: Radio<String>(
                      value: "لا",
                      visualDensity:
                          VisualDensity(horizontal: -2, vertical: -2),
                      groupValue: _selectedOption,
                      activeColor: AppColorsManager.mainDarkBlue,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                        widget.onOptionSelected(value!);
                      },
                    ),
                  ),
                  Text(
                    "لا",
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      color: AppColorsManager.textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.containerValidationColor ==
            AppColorsManager.redBackgroundValidationColor)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              context.translate.required_field,
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
            ),
          ),
      ],
    );
  }
}
