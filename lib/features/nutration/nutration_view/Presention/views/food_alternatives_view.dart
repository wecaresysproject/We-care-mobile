import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class FoodAlternativesView extends StatelessWidget {
  const FoodAlternativesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: Column(
        children: [
          // Header
          // HeaderWidget(),
          AppBarWithCenteredTitle(
            title: 'بدائل غذائية (البروتين)',
            showActionButtons: false,
          ).paddingSymmetricHorizontal(16),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Vegetables and Grains Section
                  SectionHeaderWidget(
                    title: 'الخضار والفواكه والحبوب (الكمية لكل 100 جم)',
                    icon: '🥗',
                  ),
                  verticalSpacing(10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return FoodCard(
                        name: 'عدس مطبوخ',
                        percent: '14%',
                        calories: 'جم',
                        dailyProteinSecond: 'بروتين اليومي',
                      );
                    },
                  ),

                  // Meat, Fish and Manufactured Foods Section
                  SectionHeaderWidget(
                    title:
                        'اللحوم و الأسماك و الاطعمة المصنعة ( الكمية لكل 100 جم )',
                    icon: '🐟',
                  ),
                  verticalSpacing(10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 7,
                    mainAxisSpacing: 10,
                    children: [
                      FoodCard(
                        name: 'عدس مطبوخ',
                        percent: '14%',
                        calories: 'جم',
                        dailyProteinSecond: 'بروتين اليومي',
                      ),
                      FoodCard(
                        name: 'عدس مطبوخ',
                        percent: '14%',
                        calories: 'جم',
                        dailyProteinSecond: 'بروتين اليومي',
                      ),
                      FoodCard(
                        name: 'عدس مطبوخ',
                        percent: '14%',
                        calories: 'جم',
                        dailyProteinSecond: 'بروتين اليومي',
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String icon;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Color(0xffDAE9FA),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
          horizontalSpacing(6),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String name;
  final String percent;
  final String calories;
  final String dailyProteinSecond;

  const FoodCard({
    super.key,
    required this.name,
    required this.percent,
    required this.calories,
    required this.dailyProteinSecond,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
      decoration: BoxDecoration(
        color: Color(0xffF1F3F6),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Color(0xff555555),
          width: .9,
        ),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Food name in blue
          Text(
            name,
            style: AppTextStyles.font14blackWeight400.copyWith(
              color: AppColorsManager.mainDarkBlue,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          verticalSpacing(4),

          // Protein percentage and calories in same row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Daily protein requirement text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '9 جم', // ✅ using your param instead of hardcoded
                    style: AppTextStyles.font12blackWeight400.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'بروتين',
                    style: AppTextStyles.font12blackWeight400.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 10.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              horizontalSpacing(2),
              // Percentage + calories column
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    percent,
                    style: AppTextStyles.font14BlueWeight700.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'من الاحتياج\nاليومي',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font18blackWight500.copyWith(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
