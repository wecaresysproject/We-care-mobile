import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class LeftAndRightLensRowDataSection extends StatelessWidget {
  final String title;
  final TextEditingController rightController;
  final TextEditingController leftController;
  final String hintText;
  final String? Function(String?) validator;
  final TextInputType keyboardType;

  const LeftAndRightLensRowDataSection({
    super.key,
    required this.title,
    required this.rightController,
    required this.leftController,
    required this.hintText,
    required this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Right Lens
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.font18blackWight500.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                  verticalSpacing(10),
                  CustomTextField(
                    controller: rightController,
                    hintText: hintText,
                    validator: validator,
                    keyboardType: keyboardType,
                  ),
                ],
              ),
            ),

            horizontalSpacing(16.w),

            // Left Lens
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.font18blackWight500.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                  verticalSpacing(10),
                  CustomTextField(
                    controller: leftController,
                    hintText: hintText,
                    validator: validator,
                    keyboardType: keyboardType,
                  ),
                ],
              ),
            ),
          ],
        ),
        verticalSpacing(16.h),
      ],
    );
  }
}
