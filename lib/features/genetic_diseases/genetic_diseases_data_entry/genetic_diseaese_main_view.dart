import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

class GeneticDiseaeseMainView extends StatelessWidget {
  const GeneticDiseaeseMainView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBarWidget(
                haveBackArrow: true,
              ),
              verticalSpacing(130),
              GenticDiseaseButtonCard(
                iconPath: 'assets/images/add_button.png',
                title: "انشاء شجرة العائلة",
                onTap: () async {
                  await context.pushNamed(
                    Routes.familyTreeDataEntryView,
                  );
                },
              ),
              verticalSpacing(68),
              GenticDiseaseButtonCard(
                iconPath: 'assets/images/add_button.png',
                title: "الأمراض الوراثية العائلية",
                onTap: () {},
              ),
              verticalSpacing(68),
              GenticDiseaseButtonCard(
                iconPath: 'assets/images/add_button.png',
                title: "أمراضى الوراثية",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenticDiseaseButtonCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback? onTap;

  const GenticDiseaseButtonCard({
    super.key,
    required this.title,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 343.w,
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColorsManager.secondaryColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 24.w,
                  height: 24.h,
                ),
                horizontalSpacing(8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Image.asset(
              "assets/images/left_arrow_icon.png",
              width: 24.w,
              height: 24.h,
            ),
          ],
        ),
      ),
    );
  }
}
