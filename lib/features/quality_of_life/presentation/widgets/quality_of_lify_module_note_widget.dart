import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class QualityOfLifeModuleNote extends StatelessWidget {
  const QualityOfLifeModuleNote({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final normalStyle = AppTextStyles.font14BlackMedium.copyWith(
      height: 1.5,
    );

    final boldStyle = AppTextStyles.font14BlackMedium.copyWith(
      fontWeight: FontWeight.w700,
      height: 1.5,
    );

    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔴 Title
          Center(
            child: Text(
              "تنبيه هام",
              style: AppTextStyles.font16BlackSemiBold,
              textAlign: TextAlign.center,
            ),
          ),

          verticalSpacing(10),

          /// 📝 Description
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: normalStyle,
              children: [
                const TextSpan(
                  text:
                      "يُعدّ هذا الاستبيان الصحي الشهري جزءاً أساسياً من سجلك الطبي الشخصي، وأداةً فعّالة لتعقّب المخاطر الصحية والنفسية المحتملة قبل تفاقمها. ",
                ),
                const TextSpan(
                  text:
                      "إن انتظامك في الإجابة عليه شهرياً يُمكّن مقدمي الرعاية الطبية من رصد أي تغيّرات في حالتك بدقة أعلى، ويُسهم بشكل مباشر في جودة رعايتك الصحية.",
                ),
              ],
            ),
          ),

          verticalSpacing(12),

          /// 🔹 Subtitle
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "للحصول على أفضل النتائج، ",
                  style: boldStyle,
                ),
                TextSpan(
                  text: "يرجى مراعاة ما يلي:",
                  style: boldStyle,
                ),
              ],
            ),
          ),

          verticalSpacing(8),

          /// 🔸 Bullet 1
          _buildBullet(
            textSpans: [
              const TextSpan(
                text:
                    "أجب بصدق وموضوعية بناءً على ما مررت به فعلياً خلال الشهر المنصرم.",
              ),
            ],
            normalStyle: normalStyle,
          ),

          /// 🔸 Bullet 2
          _buildBullet(
            textSpans: [
              const TextSpan(
                  text: "لا تتجاهل الاستبيان أو تؤجل الإجابة عليه؛ "),
              TextSpan(
                text: "فالانتظام هو جوهر فائدته.",
                style: boldStyle,
              ),
            ],
            normalStyle: normalStyle,
          ),

          /// 🔸 Bullet 3
          _buildBullet(
            textSpans: [
              const TextSpan(text: "تذكّر أن إجاباتك تبقى "),
              TextSpan(
                text: "سجلاً سرياً",
                style: boldStyle,
              ),
              const TextSpan(text: " يعود نفعه إليك أنت أولاً."),
            ],
            normalStyle: normalStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildBullet({
    required List<TextSpan> textSpans,
    required TextStyle normalStyle,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// النقطة
          Text("• ", style: normalStyle),

          /// النص
          Expanded(
            child: RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                style: normalStyle,
                children: textSpans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
