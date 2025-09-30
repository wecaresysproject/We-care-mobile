import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/get_follow_up_report_section_model.dart';

class FoodRecomendationView extends StatelessWidget {
  const FoodRecomendationView({super.key, required this.elementName});
  final String elementName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.h),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          spacing: 16,
          children: [
            AppBarWithCenteredTitle(
              title: elementName,
              titleColor: AppColorsManager.mainDarkBlue,
              shareFunction: () {},
              showShareButtonOnly: true,
            ),
            HeaderSectionWithIcon(
              iconPath: 'assets/images/file_icon.png',
              text: "تعريف/ مرجعية سريعة",
            ),
            Text(
              "معدن أساسي وواحد من الشوارد الكهربائية (Electrolytes) الرئيسية في الجسم، ويُستهلك في الغالب على شكل ملح الطعام (كلوريد الصوديوم). يعمل الصوديوم على الحفاظ على توازن السوائل في الجسم، ويساعد في نقل الإشارات العصبية وانقباض العضلات، بما في ذلك عضلة القلب. يتواجد بشكل طبيعي في بعض الأطعمة، لكن المصدر الرئيسي لاستهلاكه في النمط الغذائي الحديث هو الأطعمة المصنعة والوجبات الجاهزة حيث يُستخدم بكثرة كمادة حافظة ومحسّن للنكهة، مثل الخبز، الجبن، اللحوم المصنعة، والصلصات. يُعد الحفاظ على مدخول متوازن منه أمراً حيوياً للصحة، حيث أن الإفراط في تناوله على المدى الطويل يرتبط بشكل مباشر بارتفاع ضغط الدم وأمراض القلب والكلى.",
              textAlign: TextAlign.justify,
              style: AppTextStyles.font14blackWeight400,
            ),
            HeaderSectionWithIcon(
              iconPath: 'assets/images/check_right.png',
              text: "المستوى الامن :1500 - 2000",
            ),
            ElevationStatusWidget(
              iconPath: 'assets/images/check_right.png',
              isHightRisk: false,
            ),
            // HeaderSectionWithIcon(
            //   iconPath: 'assets/images/person.png',
            //   text: "الأعضاء الأكثر تأثراً مع الوقت",
            // ),
            // CustomInfoSection(
            //   headerTitle: 'المستوى الإجمالى',
            //   content: "تتأثر خلال أشهر بزيادة ضغط الدم وتصلب الشرايين",
            // ),
            CustomInfoSection(
              headerTitle: 'الكلي',
              content:
                  "تتأثر في المدى المتوسط (أشهر–سنوات) بزيادة العبء الترشيحي.",
            ),
            CustomInfoSection(
              headerTitle: 'الدماغ',
              content:
                  "تتأثر في المدى المتوسط (أشهر–سنوات) بزيادة العبء الترشيحي.",
            ),
            CustomInfoSection(
              headerTitle: 'العظام',
              content:
                  "تتأثر في المدى المتوسط (أشهر–سنوات) بزيادة العبء الترشيحي.",
            ),
            HeaderSectionWithIcon(
              iconPath: 'assets/images/file_search_icon.png',
              text: "معلومات اضافية",
            ),
            CustomInfoSection(
              headerTitle: 'الجنس',
              content:
                  "الإفراط في تناول الصوديوم (الاستهلاك المرتفع) يزيد من فقدان الكالسيوم عبر البول، مما قد يساهم في زيادة خطر الإصابة بهشاشة العظام، خاصة لدى النساء بعد انقطاع الطمث.",
            ),
            CustomInfoSection(
              headerTitle: 'العمر',
              content:
                  "كبار السن أكثر حساسية لتأثيرات الصوديوم على ضغط الدم ونقص تناول الكالسيوم يزيد بشكل كبير من خطر هشاشة العظام وكسورها لدى كبار السن من كلا الجنسين, الأطفال والمراهقين يحتاجون كميات أقل من البالغين.",
            ),
            CustomInfoSection(
              headerTitle: 'النشاط',
              content:
                  "الرياضيون الذين يفقدون كميات كبيرة من الصوديوم عبر العرق قد يحتاجون إلى مدخول أعلى قليلاً لتعويض الفاقد، ولكن ضمن إطار صحي.",
            ),
            HeaderSectionWithIcon(
              iconPath: 'assets/images/custom_note.png',
              text: "المراجع الأساسية",
            ),
            BulletText(
              text: "WHO — Guideline: Sodium intake for adults and children",
            ),
            BulletText(
              text:
                  "EFSA — Scientific Opinion on Dietary Reference Values for sodium",
            ),
            BulletText(
              text:
                  "NASEM — Dietary Reference Intakes for Sodium and Potassium",
            ),
            BulletText(
              text:
                  "He FJ, MacGregor GA, Salt, blood pressure and cardiovascular disease",
            ),
            BulletText(
              text:
                  "Graudal NA et al., Effects of low-sodium diet vs. high-sodium diet on blood pressure and health outcomes",
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the content after successful API response
  Widget _buildDetailsContent(List<GetFollowUpReportSectionModel> data) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        spacing: 16,
        children: [
          AppBarWithCenteredTitle(
            title: 'تفاصيل التقرير',
            titleColor: AppColorsManager.mainDarkBlue,
            shareFunction: () {},
            showShareButtonOnly: true,
          ),
          HeaderSectionWithIcon(
            iconPath: 'assets/images/file_icon.png',
            text: "تعريف/ مرجعية سريعة",
          ),
          // CustomInfoSection(
          //   headerIcon: Icons.trending_down,
          //   headerTitle: 'المستوى الإجمالى',
          //   content: data[0].sectionContent,
          // ),

          // CustomInfoSection(
          //   headerIcon: Icons.check_circle,
          //   headerTitle: 'عدد الإجابات الإيجابية',
          //   content: data[1].sectionContent,
          // ),
          // CustomInfoSection(
          //   headerIcon: Icons.question_mark,
          //   headerTitle: 'ملاحظة',
          //   content: data[2].sectionContent,
          // ),
          // CustomInfoSection(
          //   headerIcon: Icons.psychology,
          //   headerTitle: 'ملخص الحالة',
          //   content: data[3].sectionContent,
          // ),
          // CustomInfoSection(
          //   headerIcon: Icons.edit_square,
          //   headerTitle: 'ما الذي نلاحظه في إجابتك ؟',
          //   content: data[4].sectionContent,
          // ),
          // CustomInfoSection(
          //   headerIcon: Icons.psychology,
          //   headerTitle: 'ما الذي قد يحدث داخلك؟',
          //   content: data[5].sectionContent,
          // ),
          // CustomInfoSection(
          //   headerIcon: Icons.favorite,
          //   headerTitle: 'رسالة لك من القلب',
          //   content: data[6].sectionContent,
          // ),
          // CustomInfoSection(
          //   headerIcon: Icons.edit_square,
          //   headerTitle: 'الخطوات المقترحة (قصيرة المدى)',
          //   content: data[7].sectionContent,
          // ),
          // CustomInfoSection(
          //   headerIcon: Icons.self_improvement,
          //   headerTitle: 'خطة دعم نفسي تدريجى  ( متوسط  وطويل المدى )',
          //   content: data[8].sectionContent,
          // ),
          // CustomInfoSection(
          //   headerIcon: Icons.flag,
          //   headerTitle: 'ختامًا',
          //   content: data[9].sectionContent,
          // ),
        ],
      ),
    );
  }
}

class HeaderSectionWithIcon extends StatelessWidget {
  final String iconPath;
  final String text;

  const HeaderSectionWithIcon({
    super.key,
    required this.iconPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 18,
            color: Color(0xffFEFEFE),
            height: 23,
          ),
          horizontalSpacing(8),
          Text(
            text,
            style: AppTextStyles.font18blackWight500.copyWith(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomInfoSection extends StatelessWidget {
  final String headerTitle;
  final String content;

  const CustomInfoSection({
    super.key,
    required this.headerTitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: headerTitle,
        ),
        verticalSpacing(10),
        ContentSection(content: content),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          end: Alignment.centerLeft,
          begin: Alignment.centerRight,
          colors: [
            Color(0xFFFBFDFF),
            Color(0xFFECF5FF),
          ],
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Flexible(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 6), // space for underline
                  child: Text(
                    title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 20 / 16,
                      letterSpacing: 0.16,
                      color: AppColorsManager.mainDarkBlue,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: _calculateTextWidth(title, context),
                    height: 1,
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTextWidth(String text, BuildContext context) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.16,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.rtl,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size.width;
  }
}

// Reusable content section component
class ContentSection extends StatelessWidget {
  final String content;

  const ContentSection({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: AppTextStyles.font14blackWeight400,
      textAlign: TextAlign.justify,
    );
  }
}

class BulletText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double bulletSize;
  final Color bulletColor;
  final double spacing;

  const BulletText({
    super.key,
    required this.text,
    this.style,
    this.bulletSize = 6.0,
    this.bulletColor = Colors.black,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6), // لضبط المحاذاة مع النص
          width: bulletSize,
          height: bulletSize,
          decoration: BoxDecoration(
            color: bulletColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Text(
            text,
            style: style ?? const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class ElevationStatusWidget extends StatelessWidget {
  final String iconPath;
  final bool isHightRisk;

  const ElevationStatusWidget({
    super.key,
    required this.iconPath,
    required this.isHightRisk,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 130.w,
              height: 30.h,
              padding: EdgeInsets.all(5.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    12.r,
                  ),
                  topRight: Radius.circular(
                    12.r,
                  ),
                ), // اختياري، لتدوير الحواف
                color: isHightRisk
                    ? Color(0xffE02E2E)
                    : AppColorsManager.doneColor,
              ),
              child: Row(
                children: [
                  Icon(
                    isHightRisk ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20,
                    color: Colors.white,
                  ),
                  Text(
                    isHightRisk ? "مستويات الارتفاع" : "مستويات الانخفاض",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font18blackWight500.copyWith(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ).paddingRight(60),
            Spacer(),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isHightRisk
                      ? const Color(0xffE02E2E)
                      : AppColorsManager.doneColor,
                  width: 2.0, // سمك الحدود
                ),
                borderRadius:
                    BorderRadius.circular(8), // اختياري، لتدوير الحواف
                color: Colors.transparent, // خليه شفاف لو عايز بس الحدود
              ),
              child: Text(
                "النتيجة الحالية 2200",
                style: AppTextStyles.font18blackWight500.copyWith(
                  fontSize: 12.sp,
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),
            ),
          ],
        ),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor:
                    isHightRisk ? Colors.redAccent : Colors.amberAccent,
                radius: 12.r,
              ).paddingRight(10),
              horizontalSpacing(8),
              AutoSizeText(
                isHightRisk
                    ? "أنت فى مستوى الخطر العالى"
                    : "أنت فى مستوى المراقبة والتنبيه",
                style: AppTextStyles.font18blackWight500.copyWith(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
                maxFontSize: 14,
              ),
              Spacer(),
              isHightRisk
                  ? Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "(< 4000)",
                        style: AppTextStyles.font14whiteWeight600.copyWith(
                          color: Colors.redAccent,
                        ),
                      ),
                    ).paddingLeft(10)
                  : Text(
                      "(2001 - 3000)",
                      style: AppTextStyles.font14BlueWeight700.copyWith(
                        color: Colors.yellowAccent,
                      ),
                    )
            ],
          ),
        ),
      ],
    );
  }
}
