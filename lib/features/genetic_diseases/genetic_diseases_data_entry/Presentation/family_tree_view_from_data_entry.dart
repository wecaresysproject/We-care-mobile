import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/presentation/views/family_tree_view.dart';

class FamilyTreeViewFromDataEntry extends StatelessWidget {
  const FamilyTreeViewFromDataEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: Column(
          children: [
            FamilyTreeViewCustomAppBar(),
            verticalSpacing(48),
            Text(
              "\"برجاء الضغط على القريب لكى يتم\nادخال البيانات الوراثية.\"",
              textAlign: TextAlign.center,
              style: AppTextStyles.font20blackWeight600.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            verticalSpacing(40),
            Row(
              children: [
                /// الجهة اليمنى (الأب)
                buildFatherRelativesPart(context),

                horizontalSpacing(16),

                /// الجهة اليسرى (الأم)
                buildMotherRelativesPart(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStaticItem(BuildContext context, String title, String emoji) {
    return GestureDetector(
      onDoubleTap: () async {
        await navigateToNextScreen(context);
      },
      child: Container(
        width: 80,
        height: 50,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.h),
        decoration: BoxDecoration(
          color: Color(0xff547792),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
            ),
            horizontalSpacing(
              8.w,
            ),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: Color(0xffFEFEFE),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMainItem(
      BuildContext context, String title, String emoji, Color color) {
    return GestureDetector(
      onDoubleTap: () async {
        await navigateToNextScreen(context);
      },
      child: Container(
        width: double.infinity,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          "$emoji\n$title",
          textAlign: TextAlign.center,
          style: AppTextStyles.font18blackWight500.copyWith(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Future<void> navigateToNextScreen(BuildContext context) async {
    await context.pushNamed(Routes.familyMemeberGeneticDiseaseDataEntryView);
  }

  Widget buildRelativeItem(
      BuildContext context, String title, String emoji, Color color) {
    return GestureDetector(
      onDoubleTap: () async {
        await navigateToNextScreen(context);
      },
      child: Container(
        width: 73.5.w,
        height: 47.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "$emoji\n$title",
          textAlign: TextAlign.center,
          style: AppTextStyles.font18blackWight500.copyWith(
            color: Color(0xffFEFEFE),
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildScrollableList(List<Map<String, String>> relatives, Color color) {
    return Expanded(
      child: ListView.builder(
        itemCount: relatives.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 2.h, top: 16.h),
            child: buildRelativeItem(
              context,
              relatives[index]['title']!,
              relatives[index]['emoji']!,
              color,
            ),
          );
        },
      ),
    );
  }

  Widget buildFatherRelativesPart(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildStaticItem(context, "الجد", "👴🏻"),
              horizontalSpacing(16),
              buildStaticItem(context, "الجدة", "👵🏻"),
            ],
          ),
          verticalSpacing(16),
          buildMainItem(
              context, "الأب", "🧔🏻‍♂️", AppColorsManager.mainDarkBlue),
          verticalSpacing(16),
          Wrap(
            spacing: 16,
            runAlignment: WrapAlignment.spaceEvenly,
            runSpacing: 8,
            children: [
              buildRelativeItem(context, "الأخ", "👦🏻", Color(0xff99CBE9)),
              buildRelativeItem(context, "الأخ", "👦🏻", Color(0xff99CBE9)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Row(
              children: [
                // العم
                buildScrollableList(
                  [
                    {"title": "العم", "emoji": "👨🏻"},
                    {"title": "العم", "emoji": "👨🏻"},
                    {"title": "العم", "emoji": "👨🏻"},
                  ],
                  Color(0xff5A4B8D),
                ),
                horizontalSpacing(16),
                // العمة
                buildScrollableList(
                  [
                    {"title": "العمة", "emoji": "👧🏻"},
                  ],
                  Color(0xff5A4B8D),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMotherRelativesPart(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildStaticItem(context, "الجد", "👴🏻"),
              horizontalSpacing(16),
              buildStaticItem(context, "الجدة", "👵🏻"),
            ],
          ),
          verticalSpacing(16),
          buildMainItem(
              context, "الأم", "👩🏻‍🦳", AppColorsManager.mainDarkBlue),
          verticalSpacing(16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              buildRelativeItem(
                  context, "الأخت", "👩🏻", Colors.lightBlue[100]!),
              buildRelativeItem(
                  context, "الأخت", "👩🏻", Colors.lightBlue[100]!),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Row(
              children: [
                // الخال
                buildScrollableList(
                  [
                    {"title": "الخال", "emoji": "👳🏻‍♂️"},
                  ],
                  Color(0xff5A4B8D),
                ),
                horizontalSpacing(16),

                // الخالة
                buildScrollableList(
                  [
                    {"title": "الخالة", "emoji": "👩🏻‍🦱"},
                    {"title": "الخالة", "emoji": "👩🏻‍🦱"},
                    {"title": "الخالة", "emoji": "👩🏻‍🦱"},
                  ],
                  Color(0xff5A4B8D),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
