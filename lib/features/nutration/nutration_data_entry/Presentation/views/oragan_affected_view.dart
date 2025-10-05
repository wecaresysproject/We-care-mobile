import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class OrganAffectedDetailsView extends StatelessWidget {
  final String title;

  const OrganAffectedDetailsView({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: Column(
          children: [
            AppBarWithCenteredTitle(
              title: "التأثير علي $title",
              showActionButtons: false,
              fontSize: 14,
            ),
            HeaderSectionWithContent(
              text: "السكريات",
              isHighRisk: true,
              content:
                  "يزيد من الدهون الثلاثية ، ضغط الدم ، الالتهابات ، مما يؤدى لأمراض القلب",
            ),
            HeaderSectionWithContent(
                text: "الصوديوم",
                isHighRisk: true,
                content: "تأثير رئيسى وطويل المدى ( ارتفاع ضغط الدم ) ."),
            HeaderSectionWithContent(
                text: "الكالسيوم",
                isHighRisk: false,
                content:
                    "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد النص العربي . هذا النص مثال لنص اخر يمكن استبداله"),
            HeaderSectionWithContent(
                text: "الكوليسترول",
                isHighRisk: true,
                content: "تأثير رئيسى وطويل المدى ( ارتفاع ضغط الدم ) ."),
            HeaderSectionWithContent(
                text: "الزنك",
                isHighRisk: false,
                content:
                    "هذا النص مثال لنص اخر يمكن استبداله فى نفس المساحة ، لقد تم توليد هذا النص ..............."),
            HeaderSectionWithContent(
                text: "الدهون الأحادية المشبعة",
                isHighRisk: false,
                content:
                    "هذا النص مثال لنص اخر يمكن استبداله فى نفس المساحة ، لقد تم توليد هذا النص ..............."),
          ],
        ),
      ),
    );
  }
}

class HeaderSectionWithContent extends StatelessWidget {
  final String text;
  final String content;
  final bool isHighRisk;

  const HeaderSectionWithContent({
    super.key,
    required this.text,
    required this.isHighRisk,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 5.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF5998CD),
                  Color(0xFF03508F),
                  Color(0xff2B2B2B),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: AppTextStyles.font18blackWight500.copyWith(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 25.h,
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(
                    left: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isHighRisk
                        ? AppColorsManager.criticalRisk
                        : AppColorsManager.doneColor,
                    borderRadius: BorderRadius.circular(
                      5.r,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isHighRisk ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      Text(
                        isHighRisk ? "التأثير بالارتفاع" : "التأثير بالانخفاض",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.font14whiteWeight600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          verticalSpacing(10),
          Text(
            content,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}
