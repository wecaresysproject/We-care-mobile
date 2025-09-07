import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class InstructionText extends StatelessWidget {
  const InstructionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'يرجى إدخال جميع الوجبات والمشروبات التي تم تناولها خلال فترات اليوم بالكامل بأكبر قدر من الدقة والتفصيل، مع مراعاة توضيح المقادير بالملعقة أو الطبق أو القطع أو الجرام أو رشة صغيرة',
      textAlign: TextAlign.center,
      style: AppTextStyles.font18blackWight500.copyWith(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
