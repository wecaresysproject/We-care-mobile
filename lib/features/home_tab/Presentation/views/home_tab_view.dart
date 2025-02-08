import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_elevated_button.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/home_tab/Presentation/views/widgets/custom_home_app_bar.dart';
import 'package:we_care/features/home_tab/Presentation/views/widgets/faq_section_widget.dart';
import 'package:we_care/features/home_tab/Presentation/views/widgets/home_crausal_widget.dart';
import 'package:we_care/features/home_tab/Presentation/views/widgets/home_second_category_widget.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 50.h),
          child: Column(
            children: [
              HomeCustomAppBarWidget(),
              verticalSpacing(10),
              HomeCarouselWidget(),
              verticalSpacing(8),
              Image.asset("assets/images/panner.png"),
              Image.asset("assets/images/indicators.png"),
              verticalSpacing(16),
              SizedBox(
                height: 100.h,
                width: double.infinity,
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16.w,
                  crossAxisSpacing: 16.h,
                  children: [
                    CustomElevatedButton(
                      text: "ملفى الطبى",
                      onPressed: () {},
                    ),
                    CustomElevatedButton(
                      text: "اختبار توافق أدويتى",
                      onPressed: () {},
                    ),
                    CustomElevatedButton(
                      text: "زيارة طبية للمنزل",
                      onPressed: () {},
                    ),
                    CustomElevatedButton(
                      text: "طبيبك أونلاين",
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              verticalSpacing(32),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate the width of each grid item
                  double totalSpacing =
                      (4 - 1) * 16.w; // if crossAxisSpacing is 16.w
                  double itemWidth = (constraints.maxWidth - totalSpacing) / 4;
                  // Suppose your item needs a height of about 1.5 times its width
                  double itemHeight = itemWidth * 1.5;

                  return SizedBox(
                    height: 215
                        .h, // or you can remove the fixed height to let it adapt
                    child: GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: itemWidth / itemHeight,
                      physics: const NeverScrollableScrollPhysics(),
                      cacheExtent: 0.0,
                      crossAxisSpacing: 13.w,
                      children: [
                        HomeSecondCategoryItem(
                          categoryName: "استشر الذكاء\nالاصطناعي",
                          imagePath: "assets/images/ai_image.png",
                          onTap: () {},
                        ),
                        HomeSecondCategoryItem(
                          categoryName: "امراضى\nالوراثيه",
                          imagePath: "assets/images/icon_family.png",
                          onTap: () {},
                        ),
                        HomeSecondCategoryItem(
                          categoryName: "لست\nوحدك",
                          imagePath: "assets/images/support_rooms_icon.png",
                          onTap: () {},
                        ),
                        HomeSecondCategoryItem(
                          categoryName: "تقاريرى\nالطبية",
                          imagePath: "assets/images/medical_file_icon.png",
                          onTap: () {
                            context.pushNamedWithSettingRootNavigator(
                              Routes.viewOrEditMedicalRecord,
                            );
                          },
                        ),
                        HomeSecondCategoryItem(
                          categoryName: "جودة\nالحياة",
                          imagePath: "assets/images/quality_of_life.png",
                          onTap: () {},
                        ),
                        HomeSecondCategoryItem(
                          categoryName: "بحث عن\nطبيب",
                          imagePath: "assets/images/search_for_doctor_icon.png",
                          onTap: () {},
                        ),
                        HomeSecondCategoryItem(
                          categoryName: "تقييم\nالاطباء",
                          imagePath: "assets/images/doctors_evaluation.png",
                          onTap: () {},
                        ),
                        HomeSecondCategoryItem(
                          categoryName: "الاعدادات\n",
                          imagePath: "assets/images/setting_icon.png",
                          onTap: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
              verticalSpacing(30),
              Image.asset("assets/images/home_screen_videos.png"),

              verticalSpacing(32),

              /// Frequently asked questions
              FAQSectionWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
