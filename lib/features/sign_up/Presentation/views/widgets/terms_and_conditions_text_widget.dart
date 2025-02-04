import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/bottom_sheet_child.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class TermsAndConditionsTextWidget extends StatelessWidget {
  final bool isAccepted;
  const TermsAndConditionsTextWidget({
    super.key,
    required this.isAccepted,
    required this.onAccepted,
  });
  final Function(bool) onAccepted;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            onAccepted(!isAccepted);
          },
          child: Container(
            width: 22.w,
            height: 22.h,
            decoration: BoxDecoration(
              color: isAccepted
                  ? AppColorsManager.mainDarkBlue
                  : Colors.transparent,
              border: Border.all(
                color: AppColorsManager.mainDarkBlue,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Opacity(
              opacity: isAccepted ? 1 : 0,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 15.r,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 7),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: context.translate.by_creating_account_you_agree_to,
                    style: AppTextStyles.font12blackRegular.copyWith(
                      color: AppColorsManager.textColor,
                      fontSize: 12.sp,
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          builder: (context) => ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: context.screenHeight * 0.7,
                            ),
                            child: const TermsAndConditionView(),
                          ),
                        );
                      },
                    text: context.translate.conditionsOFUse,
                    style: AppTextStyles.font12blackRegular.copyWith(
                      color: AppColorsManager.mainDarkBlue,
                      fontSize: 12.sp,
                      fontWeight: FontWeightHelper.bold,
                    ),
                  ),
                ],
                style: AppTextStyles.font16DarkGreyWeight400,
              ),
            ),
          ),
        )
      ],
    ).paddingSymmetricHorizontal(20);
  }
}

class TermsAndConditionView extends StatelessWidget {
  const TermsAndConditionView({super.key});

  final String termsAndConditionsArabic = """
• أُقر بأنني قد قرأت وفهمت وأوافق على شروط الاستخدام
  وسياسة الخصوصية الخاصة بمنصة WeCare.

• أوافق طوعًا على جمع ومعالجة وتخزين بياناتي الشخصية
  بشكل آمن وفقًا لما هو موضح في سياسة الخصوصية.

• أفهم أن بياناتي محمية، ويحق لي الوصول إلى معلوماتي
  الشخصية أو تعديلها أو حذفها في أي وقت.

• أقر بأن بياناتي الصحية قد تُستخدم لتحسين تجربتي وتعزيز
  جودة الخدمات الطبية المقدمة لي.

• أدرك أن لدي الحق في سحب موافقتي في أي وقت عبر التواصل
  مع خدمة العملاء أو من إعدادات حسابي.
""";

  final String termsAndConditionsEnglish = """
• I acknowledge that I have read, understood, and agree
  to the Terms of Use and Privacy Policy of the WeCare platform.

• I voluntarily consent to the collection, processing,
  and secure storage of my personal data as outlined
  in the Privacy Policy.

• I understand that my data is protected, and I have the right
  to access, modify, or delete my personal information at any time.

• I acknowledge that my health data may be used to enhance my experience
  and improve the quality of medical services provided to me.

• I recognize that I have the right to withdraw my consent
  at any time by contacting customer support or through
  my account settings.
""";

  @override
  Widget build(BuildContext context) {
    return BottomSheetChildWidget(
      title: context.translate.T_and_C,
      text: isArabic() ? termsAndConditionsArabic : termsAndConditionsEnglish,
    );
  }
}
