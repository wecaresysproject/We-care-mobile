import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class FamilyQuestionField extends StatelessWidget {
  const FamilyQuestionField({
    super.key,
    required this.question,
    this.hint = "##",
    this.onChanged,
  });
  final String question;
  final String hint;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          question,
          textAlign: TextAlign.center,
          style: AppTextStyles.font18blackWight500,
        ),
        Spacer(),
        SizedBox(
          width: 135.w,
          child: CustomTextField(
            hintText: "##",
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "هذا الحقل مطلوب";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
