import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class MedicalInformationNotice extends StatelessWidget {
  const MedicalInformationNotice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            "تنويه:",
            style: AppTextStyles.font16BlackSemiBold,
            textAlign: TextAlign.center,
          ),
          verticalSpacing(8),
          Text(
            "هذا الموديل لا يقدم استشارة أو رأيا طبيا، ولا يغني عن مراجعة الطبيب أو الصيدلي المختص. تعتمد النتائج على تحليل سجلك الصحي والمرضي باستخدام نماذج ذكاء اصطناعي معروفة، بهدف تزويدك بمعلومات إرشادية تساعدك على التواصل الفعال مع الطبيب، وطرح الأسئلة المناسبة، والتنبيه إلى نقاط الخطر المحتملة، والأخطاء التي قد تنتج عن تشخيص غير دقيق أو وصف أدوية لا تتناسب مع حالتك الصحية، أو أدويتك الحالية، أو أمراضك المزمنة، أو نتائج التحاليل الطبية.",
            style: AppTextStyles.font14BlackMedium.copyWith(
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
