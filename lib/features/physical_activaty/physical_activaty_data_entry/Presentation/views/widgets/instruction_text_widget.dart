import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class InstructionText extends StatelessWidget {
  const InstructionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'لضمان دقة تقييم النشاط العضلي، يُرجى إدخال عدد الدقائق التي تمارس فيها التمرين كفترات متصلة من الجهد البدني المقصود ( المشي السريع، الجري، أو التمارين الرياضية المنتظمة المتنوعه). الهدف هو ضمان تنشيط العضلات وتحقيق الفائدة الفسيولوجية من التمرين، بما في ذلك تحسين اللياقة، وزيادة الكتلة العضلية، وتعزيز التمثيل الغذائي. لذلك، يُستبعد من الحساب المشي داخل المولات أو الأسواق أو أثناء الأنشطة اليومية الاعتيادية، لأنها لا تحقق مستوى الشدة والاستمرارية المطلوبين لتحفيز الصيانة أو البناء العضلي',
      textAlign: TextAlign.center,
      style: AppTextStyles.font18blackWight500.copyWith(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
