import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class FAQSectionWidget extends StatefulWidget {
  const FAQSectionWidget({super.key});

  @override
  FAQSectionWidgetState createState() => FAQSectionWidgetState();
}

class FAQSectionWidgetState extends State<FAQSectionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColorsManager.backGroundColor,
      surfaceTintColor: Colors.red,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r), // Adjusted border radius
        side: BorderSide(
          color: _isExpanded
              ? AppColorsManager.mainDarkBlue
              : AppColorsManager.placeHolderColor.withAlpha(150),
          style: BorderStyle.solid,
        ),
      ),
      child: ExpansionTile(
        trailing: Image.asset(
          _isExpanded
              ? "assets/images/arrow_up.png"
              : "assets/images/arrow_down.png",
          height: 8.h,
          width: 17.w,
        ),
        backgroundColor: AppColorsManager.backGroundColor,
        collapsedIconColor: AppColorsManager.placeHolderColor,
        collapsedBackgroundColor: AppColorsManager.backGroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
          side: BorderSide(
            width: _isExpanded ? 1.5 : 1,
            strokeAlign: 70,
            color: AppColorsManager.placeHolderColor.withAlpha(
              150,
            ),
          ),
        ),
        tilePadding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        leading: Image.asset(
          "assets/images/faq_section_icon.png",
          width: 21.6.w,
          height: 19.5.h,
          color: _isExpanded
              ? AppColorsManager.mainDarkBlue
              : AppColorsManager.placeHolderColor,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "الأسئلة الشائعة",
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        children: [
          Divider(
            color: _isExpanded
                ? AppColorsManager.mainDarkBlue
                : AppColorsManager.placeHolderColor,
          ), // Adds a divider between items
          _buildFAQItem("كيف يمكنني إنشاء حساب جديد في التطبيق؟",
              "يمكنك إنشاء حساب جديد بالنقر على \"إنشاء حساب\" ثم إدخال بياناتك الشخصية مثل الاسم البريد الإلكتروني وكلمة المرور."),
          Divider(), // Adds a divider between items
          _buildFAQItem("ما الخدمات الطبية التي يقدمها التطبيق؟",
              "يقدم التطبيق خدمات مثل الاستشارات الطبية، حجز المواعيد، متابعة السجلات الطبية والتذكير بمواعيد الأدوية والفحوصات."),
          Divider(), // Adds a divider between items
          _buildFAQItem("كيف أحجز موعدًا مع طبيب؟",
              "انتقل إلى قسم \"حجز المواعيد\"، اختر التخصص، الطبيب، والوقت المناسب، ثم قم بتأكيد الحجز."),
          Divider(), // Adds a divider between items
          _buildFAQItem("هل يقدم التطبيق استشارات طبية عن بعد؟",
              "نعم، يمكنك الاستفادة من خدمات الاستشارات الطبية عبر مكالمات الفيديو أو الرسائل النصية للتواصل مع الأطباء."),
        ],
        onExpansionChanged: (expanded) {
          setState(
            () {
              _isExpanded = expanded;
            },
          );
        },
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question (Header)
          Text(
            question,
            style: AppTextStyles.font22MainBlueWeight700.copyWith(
              color: AppColorsManager.textColor,
              fontSize: 12.sp,
            ),
          ),
          // Answer (Description)
          Text(
            answer,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
