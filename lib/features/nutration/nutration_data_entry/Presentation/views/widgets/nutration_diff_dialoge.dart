import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
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
            SizedBox(height: 20.h),

            // Consumed and Standard amounts row
            Row(
              children: [
                // Standard Amount (Right)
                Expanded(
                  child: Column(
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
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: AppColorsManager.mainDarkBlue,
                            width: 1.5,
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
                SizedBox(width: 16.w),

                // Consumed Amount (Left)
                Expanded(
                  child: Column(
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
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColorsManager.mainDarkBlue,
                            width: 1.5,
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
            SizedBox(height: 20.h),

            // Difference section
            Column(
              children: [
                Text(
                  "الفرق",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColorsManager.mainDarkBlue,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFF00BCD4),
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
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isDeficit ? "أقل من المستهدف" : "أكثر من المستهدف",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              isDeficit ? Icons.arrow_downward : Icons.arrow_upward,
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
                // Recommendations Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                    context.pushNamed(Routes.foodRecomendationView,
                      arguments: elementName,);
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
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Food Alternatives Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(Routes.foodAlternativesView,
                        arguments: elementName,);
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
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_back,
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