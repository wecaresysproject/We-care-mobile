import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/widgets/custom_image_with_text_medical_illnesses_module_widget.dart';

class MentalIllnessOrMindUmbrellaViewDataEntryView extends StatelessWidget {
  const MentalIllnessOrMindUmbrellaViewDataEntryView({
    super.key,
  });

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
                verticalSpacing(113),
                CustomImageWithTextMedicalIllnessModuleWidget(
                  onTap: () async {
                    await context.pushNamed(
                      Routes.mentalIllnessesDataEntryView,
                    );
                  },
                  imagePath: "assets/images/medical_illnesses_icon.png",
                  text: "الأمراض النفسية",
                  textStyle: AppTextStyles.font22WhiteWeight600.copyWith(
                    fontSize: 24.sp,
                  ),
                  isTextFirst: false,
                ),
                verticalSpacing(88),
                CustomImageWithTextMedicalIllnessModuleWidget(
                  onTap: () {},
                  imagePath:
                      "assets/images/medical_illnesses_umbrella_icon.png",
                  text: "المظلة النفسية",
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
