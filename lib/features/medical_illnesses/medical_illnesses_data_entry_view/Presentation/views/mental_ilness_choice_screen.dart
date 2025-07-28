import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

class MentalIllnessChoiceScreen extends StatelessWidget {
  const MentalIllnessChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAppBarWidget(
                haveBackArrow: true,
              ),

              verticalSpacing(72),

              // Main Question
              Text(
                'هل تود تفعيل المتابعة النفسية الآمنة\nضمن مظلة WECARE؟',
                textAlign: TextAlign.center,
                style: AppTextStyles.font22MainBlueWeight700.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColorsManager.textColor,
                  fontSize: 20.sp,
                ),
              ),
              verticalSpacing(40),
              // Buttons
              _buildOptionButton(
                label:
                    'أود تلقى المتابعة النفسية', //! disable border color and its text inside it , handle it with backend in sha2allah
                iconPath: "assets/images/check_right.png",
                onTap: () async {
                  await context.pushNamed(
                    Routes.enableViewForWeCareMentalHealthUmbrella,
                  );
                },
              ),
              verticalSpacing(32),
              _buildOptionButton(
                label:
                    'أود التفعيل لاحقا', //! الغاء التفعيل ، in case it enabled by user and return back to this screen , handled with backend
                iconPath: "assets/images/check_wrong.png",
                onTap: () async {
                  await context.pushNamed(
                    Routes.disableViewForWeCareMentalHealthUmbrella,
                  );
                },
                iconColor: Colors.red,
              ),

              verticalSpacing(72),

              // Go to genetic diseases
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    iconSize: 28.sp,
                    backgroundColor: Color(0xFF003E78), // dark blue
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () async {
                    await context.pushNamed(
                      Routes.mentalIllnessesDataEntryView,
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: Text(
                    'الذهاب للأمراض النفسية',
                    style: AppTextStyles.font22WhiteWeight600.copyWith(
                      fontSize: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required String iconPath, // e.g., "assets/icons/check.svg"
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColorsManager.mainDarkBlue,
            width: 1.5,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 16.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 22.w,
              height: 22.h,
              color: iconColor ?? AppColorsManager.mainDarkBlue,
            ),
            horizontalSpacing(12),
            Text(
              label,
              style: AppTextStyles.font20blackWeight600.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
