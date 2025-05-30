import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/home_tab/Presentation/views/widgets/custom_text_with_image_button.dart';

class ViewOrEditMedicalRecord extends StatelessWidget {
  const ViewOrEditMedicalRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                CustomAppBarWidget(
                  haveBackArrow: true,
                ),
                verticalSpacing(32),
                Text(
                  context.translate.medicalRecordManagement,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: AppTextStyles.font22MainBlueWeight700.copyWith(
                    color: AppColorsManager.textColor,
                    fontFamily: "Rubik",
                    fontWeight: FontWeightHelper.medium,
                  ),
                ),
                verticalSpacing(60),
                CustomImageWithTextButtonHomeWidget(
                  onTap: () async {
                    await context.pushNamed(Routes.medicalDataEntryTypesView);
                  },
                  imagePath: "assets/images/we_care_sys_data_entry.png",
                  text: isArabic()
                      ? "ادخال بيانات\nسجلك الطبي"
                      : "Enter medical\n record data",
                  textStyle: AppTextStyles.font22WhiteWeight600.copyWith(
                    fontSize: 24.sp,
                  ),
                  isTextFirst: true,
                ),
                verticalSpacing(88),
                CustomImageWithTextButtonHomeWidget(
                  onTap: () async {
                    await context.pushNamed(Routes.medicalCategoriesTypesView);
                  },
                  imagePath: "assets/images/we_care_sys_show_data.png",
                  text: isArabic()
                      ? "عرض بيانات\nسجلك الطبي"
                      : "View medical\nrecord",
                  textStyle: AppTextStyles.font22WhiteWeight600.copyWith(
                    fontSize: 24.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
