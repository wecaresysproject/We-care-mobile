import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/data/models/element_recommendation_response_model.dart';
import 'package:we_care/features/nutration/nutration_view/logic/nutration_view_cubit.dart';

class FoodRecomendationView extends StatelessWidget {
  const FoodRecomendationView({super.key, required this.elementName});
  final String elementName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<NutrationViewCubit>()
        ..getElementRecommendations(elementName: elementName),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0.h),
        body: BlocBuilder<NutrationViewCubit, NutrationViewState>(
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                    color: AppColorsManager.mainDarkBlue),
              );
            }

            final elementRecommendation = state.elementRecommendation;

            if (elementRecommendation == null) {
              return const Center(
                child: Text('لم يتم العثور على بيانات لهذا العنصر'),
              );
            }

            final riskLevels = elementRecommendation.riskLevels;
            final organEffects = elementRecommendation.organEffectsOverTime;
            final supplementaryInfo =
                elementRecommendation.supplementaryInformation;
            final references = elementRecommendation.references;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  /// Header with title and share button
                  AppBarWithCenteredTitle(
                    title: elementName,
                    titleColor: AppColorsManager.mainDarkBlue,
                    shareFunction: () => shareFoodRecommendation(elementName),
                    showShareButtonOnly: true,
                  ),
                  verticalSpacing(12),

                  /// تعريف / مرجعية سريعة
                  HeaderSectionWithIcon(
                    iconPath: 'assets/images/file_icon.png',
                    text: "تعريف/ مرجعية سريعة",
                  ),
                  verticalSpacing(8),

                  Text(
                    elementRecommendation.quickOverview,
                    textAlign: TextAlign.justify,
                    style: AppTextStyles.font14blackWeight400,
                  ),

                  /// المستوى الآمن
                  HeaderSectionWithIcon(
                    iconPath: 'assets/images/check_right.png',
                    text: "المستوى الامن : ${elementRecommendation.safeLevel}",
                  ),
                  verticalSpacing(16),

                  riskLevels == null
                      ? const SizedBox()
                      : Column(
                          children: [
                            ElevationStatusWidget(
                              iconPath: 'assets/images/check_right.png',
                              riskLevels: riskLevels,
                            ),
                            verticalSpacing(10),

                            /// تفاصيل المخاطر
                            ...riskLevels.risks.map(
                              (risk) => risk.description.isEmptyOrNull
                                  ? const SizedBox.shrink()
                                  : CustomInfoSection(
                                      headerTitle: risk.title,
                                      content: risk.description,
                                    ),
                            ),
                          ],
                        ),

                  /// مستوى الخطورة
                  organEffects == null
                      ? const SizedBox()
                      : Column(
                          children: [
                            HeaderSectionWithIcon(
                              iconPath: 'assets/images/person.png',
                              text: "الأعضاء الأكثر تأثراً مع الوقت",
                            ),
                            verticalSpacing(10),
                            ...organEffects.map(
                              (effect) {
                                if (effect.description.isEmptyOrNull) {
                                  return const SizedBox.shrink();
                                }
                                return CustomInfoSection(
                                  headerTitle: effect.title,
                                  content: effect.description,
                                ).paddingBottom(10);
                              },
                            ),
                          ],
                        ),

                  /// الأعضاء الأكثر تأثراً مع الوقت

                  /// معلومات إضافية
                  HeaderSectionWithIcon(
                    iconPath: 'assets/images/file_search_icon.png',
                    text: "معلومات إضافية",
                  ),
                  verticalSpacing(10),

                  ...supplementaryInfo.map(
                    (info) {
                      if (info.description.isEmptyOrNull) {
                        return const SizedBox.shrink();
                      }
                      return CustomInfoSection(
                        headerTitle: info.title,
                        content: info.description,
                      );
                    },
                  ),

                  verticalSpacing(16),

                  /// المراجع الأساسية
                  HeaderSectionWithIcon(
                    iconPath: 'assets/images/custom_note.png',
                    text: "المراجع الأساسية",
                  ),
                  verticalSpacing(10),
                  ...references.map(
                    (ref) => BulletText(text: ref),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void shareFoodRecommendation(String elementName) {
    final contentBuffer = StringBuffer();

    // العنوان الرئيسي
    contentBuffer.writeln("🔹 $elementName\n");

    // تعريف
    contentBuffer.writeln("📘 تعريف/ مرجعية سريعة:");
    contentBuffer
        .writeln("معدن أساسي وواحد من الشوارد الكهربائية (Electrolytes) ...\n");

    // المستوى الآمن
    contentBuffer.writeln("✅ المستوى الآمن: 1500 - 2000\n");

    // التأثيرات
    contentBuffer.writeln("⚡ التأثير قصير المدى:");
    contentBuffer.writeln(
        "خلال أسابيع إلى أشهر: قد لا تظهر أعراض واضحة، لكنه يضع عبئًا إضافيًا على الكلى ويساهم في احتباس السوائل.\n");

    contentBuffer.writeln("⚡ التأثير طويل المدى:");
    contentBuffer.writeln(
        "عدة سنوات: يزيد بشكل مؤكد من خطر الإصابة بـ ارتفاع ضغط الدم وأمراض القلب...\n");

    contentBuffer.writeln("⚡ الإجراء:");
    contentBuffer.writeln(
        "مراجعة مصادر الصوديوم الخفية في النظام الغذائي والعمل على تقليلها تدريجياً.\n");

    // الأعضاء الأكثر تأثراً
    contentBuffer.writeln("🧍 الأعضاء الأكثر تأثراً:");
    contentBuffer
        .writeln("القلب والأوعية الدموية: تتأثر خلال أشهر بزيادة ضغط الدم.\n");
    contentBuffer.writeln("الكلى: تتأثر في المدى المتوسط (أشهر–سنوات).\n");
    contentBuffer.writeln("الدماغ: تتأثر في المدى المتوسط.\n");
    contentBuffer.writeln("العظام: تتأثر في المدى المتوسط.\n");

    // معلومات إضافية
    contentBuffer.writeln("ℹ️ معلومات إضافية:");
    contentBuffer
        .writeln("الجنس: الإفراط في تناول الصوديوم يزيد من فقدان الكالسيوم.\n");
    contentBuffer.writeln(
        "العمر: كبار السن أكثر حساسية لتأثيرات الصوديوم على ضغط الدم.\n");
    contentBuffer
        .writeln("النشاط: الرياضيون قد يحتاجون لمستويات أعلى قليلاً.\n");

    // المراجع
    contentBuffer.writeln("📚 المراجع الأساسية:");
    contentBuffer
        .writeln("• WHO — Guideline: Sodium intake for adults and children");
    contentBuffer.writeln(
        "• EFSA — Scientific Opinion on Dietary Reference Values for sodium");
    contentBuffer.writeln(
        "• NASEM — Dietary Reference Intakes for Sodium and Potassium");
    contentBuffer.writeln(
        "• He FJ, MacGregor GA, Salt, blood pressure and cardiovascular disease");
    contentBuffer.writeln(
        "• Graudal NA et al., Effects of low-sodium diet vs. high-sodium diet\n");

    // عمل شير
    Share.share(contentBuffer.toString(),
        subject: "توصية غذائية: $elementName");
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

  final RiskLevels riskLevels;
  const ElevationStatusWidget({
    super.key,
    required this.iconPath,
    required this.riskLevels,
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
                color: riskLevels.isHighRiskLevel
                    ? Color(0xffE02E2E)
                    : AppColorsManager.doneColor,
              ),
              child: Row(
                children: [
                  Icon(
                    riskLevels.isHighRiskLevel
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 20,
                    color: Colors.white,
                  ),
                  Text(
                    riskLevels.isHighRiskLevel
                        ? "مستويات الارتفاع"
                        : "مستويات الانخفاض",
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
                  color: riskLevels.isHighRiskLevel
                      ? const Color(0xffE02E2E)
                      : AppColorsManager.doneColor,
                  width: 2.0, // سمك الحدود
                ),
                borderRadius:
                    BorderRadius.circular(8), // اختياري، لتدوير الحواف
                color: Colors.transparent, // خليه شفاف لو عايز بس الحدود
              ),
              child: Text(
                "النتيجة الحالية ${riskLevels.actualValue}",
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
                backgroundColor: riskLevels.isHighRiskLevel
                    ? Colors.redAccent
                    : Colors.amberAccent,
                radius: 12.r,
              ).paddingRight(10),
              horizontalSpacing(8),
              AutoSizeText(
                riskLevels.isHighRiskLevel
                    ? "أنت فى مستوى الخطر العالى"
                    : "أنت فى مستوى المراقبة والتنبيه",
                style: AppTextStyles.font18blackWight500.copyWith(
                  fontSize: 13.sp,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              riskLevels.isHighRiskLevel
                  ? Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "(${riskLevels.indicatorValue})",
                        style: AppTextStyles.font14whiteWeight600.copyWith(
                          color: Colors.redAccent,
                        ),
                      ),
                    ).paddingLeft(10)
                  : Text(
                      "(${riskLevels.indicatorValue})",
                      style: AppTextStyles.font14BlueWeight700.copyWith(
                        color: Colors.yellowAccent,
                      ),
                    ).paddingLeft(4),
            ],
          ),
        ),
      ],
    );
  }
}
