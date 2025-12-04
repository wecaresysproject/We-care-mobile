import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_elevated_button.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/contact_support/presentation/views/contact_support_modal.dart';
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
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 4 / 1,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16.w,
                crossAxisSpacing: 16.h,
                children: [
                  CustomElevatedButton(
                    text: "ملفى الطبى",
                    onPressed: () async {
                      await context.pushNamedWithSettingRootNavigator(
                        Routes.viewOrEditMedicalRecord,
                      );
                    },
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
              verticalSpacing(15),
              GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1 / 1.7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
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
                    onTap: () {},
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
                    categoryName: "مفكرتي\n الطبية",
                    imagePath: "assets/images/medical_note.png",
                    onTap: () async {
                      await context.pushNamedWithSettingRootNavigator(
                        Routes.medicalNotesView,
                      );
                    },
                  ),
                ],
              ),
              verticalSpacing(16),

              GestureDetector(
                onTap: () {
                  ContactSupportModal.show(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  width: double.infinity ,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF4F5F5), Color(0xFFDFEFFC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/Chat.png",width: 36.w,height: 28.h,),
                      horizontalSpacing(8),
                      Text(
                        "تواصل معنا",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColorsManager.mainDarkBlue),
                      ),
                      
                    ],
                  ),
                ),
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
