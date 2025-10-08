import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

class NutritionDifferenceDialog extends StatelessWidget {
  final String elementName;
  final String consumedAmount;
  final String standardAmount;
  final String difference;
  final bool isDeficit; // true if less than standard

  const NutritionDifferenceDialog({
    super.key,
    required this.elementName,
    required this.consumedAmount,
    required this.standardAmount,
    required this.difference,
    required this.isDeficit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: 12.w), // يتحكم في المسافة من أطراف الشاشة

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, // ياخد العرض كله
        ),
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Color(0xFFF1F3F6),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColorsManager.mainDarkBlue,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              elementName,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'Cairo',
              ),
            ),
            verticalSpacing(20),

            // Consumed and Standard amounts row
            Row(
              children: [
                // Standard Amount (Right)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "الكمية المعيارية",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColorsManager.mainDarkBlue,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffFBFDFF),
                              Color(0xffECF5FF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: AppColorsManager.mainDarkBlue,
                            width: .3,
                          ),
                        ),
                        child: Text(
                          standardAmount,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                horizontalSpacing(16),

                // Consumed Amount (Left)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "الكمية المستهلكة",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColorsManager.mainDarkBlue,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      verticalSpacing(8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffFBFDFF),
                              Color(0xffECF5FF),
                            ],
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColorsManager.mainDarkBlue,
                            width: .3,
                          ),
                        ),
                        child: Text(
                          consumedAmount,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            verticalSpacing(20),

            // Difference section
            Column(
              children: [
                Text(
                  "الفرق",
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffFBFDFF),
                        Color(0xffECF5FF),
                      ],
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColorsManager.doneColor,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        difference,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColorsManager.doneColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isDeficit
                                  ? "أقل من المستهدف"
                                  : "أكثر من المستهدف",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              isDeficit
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Action Buttons
            Row(
              children: [
                // Food Alternatives Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await context.pushNamed(
                        Routes.foodAlternativesView,
                        arguments: elementName,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorsManager.mainDarkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "بدائل غذائية",
                          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                horizontalSpacing(12),

                // Recommendations Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await context.pushNamed(
                        Routes.foodRecomendationView,
                        arguments: elementName,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorsManager.mainDarkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "توصيات",
                          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to show the dialog
  static Future<void> show(
    BuildContext context, {
    required String elementName,
    required String consumedAmount,
    required String standardAmount,
    required String difference,
    required bool isDeficit,
  }) {
    return showDialog(
      context: context,
      builder: (context) => NutritionDifferenceDialog(
        elementName: elementName,
        consumedAmount: consumedAmount,
        standardAmount: standardAmount,
        difference: difference,
        isDeficit: isDeficit,
      ),
    );
  }
}
