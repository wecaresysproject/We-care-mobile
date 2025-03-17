import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class TrueOrFalseQuestionWidget extends StatefulWidget {
  final String question;
  final String imagePath;
  final Color containerValidationColor;

  final Function(String) onOptionSelected;

  const TrueOrFalseQuestionWidget({
    super.key,
    required this.question,
    required this.imagePath,
    this.containerValidationColor = AppColorsManager.babyBlueColor,
    required this.onOptionSelected,
  });

  @override
  TrueOrFalseQuestionWidgetState createState() =>
      TrueOrFalseQuestionWidgetState();
}

class TrueOrFalseQuestionWidgetState extends State<TrueOrFalseQuestionWidget> {
  String? _selectedOption; // Initially no selection

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,

          padding:
              EdgeInsets.fromLTRB(8, 8, 16, 0.h), // Padding as per the design
          decoration: BoxDecoration(
            color: widget.containerValidationColor,
            borderRadius: BorderRadius.circular(16), // Radius as per the design
          ),
          child: Column(
            // mainAxisAlignment:
            //     MainAxisAlignment.spaceBetween, // Space between items
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Icon Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    widget.imagePath,
                    width: 24.w,
                    height: 24.h,
                  ),
                  horizontalSpacing(7), // Spacing between icon and title
                  Expanded(
                    child: Text(
                      widget.question,
                      style: AppTextStyles.font18blackWight500,
                    ),
                  ),
                ],
              ),
              verticalSpacing(8),
              // Radio Buttons for "نعم" and "لا" //TODO: make them in different languages
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 1.4,
                    child: Radio<String>(
                      value: "نعم", // context.translate.yes,
                      // fillColor: WidgetStateProperty.all(
                      //   AppColorsManager.placeHolderColor,
                      // ),
                      groupValue: _selectedOption,
                      activeColor: AppColorsManager.mainDarkBlue,
                      visualDensity:
                          VisualDensity(horizontal: -2, vertical: -2),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                        widget.onOptionSelected(
                            value!); //TODO check null here laters
                      },
                    ),
                  ),
                  Text(
                    "نعم",
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      color: AppColorsManager.textColor,
                    ),
                  ),
                  horizontalSpacing(16), // Spacing between radio buttons
                  Transform.scale(
                    scale: 1.4,
                    child: Radio<String>(
                      value: "لا", //context.translate.no,

                      // fillColor: WidgetStateProperty.all(
                      //   AppColorsManager.placeHolderColor,
                      // ),
                      visualDensity:
                          VisualDensity(horizontal: -2, vertical: -2),
                      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
            AppColorsManager
                .redBackgroundValidationColor) // Show error message if required and not selected
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
