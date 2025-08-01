import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_model.dart';

class MentalIllnessItemCardHorizontal extends StatelessWidget {
  final MentalIllnessModel medicalItem;
  final VoidCallback? onArrowTap;

  const MentalIllnessItemCardHorizontal({
    super.key,
    required this.medicalItem,
    this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onArrowTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, 1),
              blurRadius: 3,
            )
          ],
          border: Border.all(color: Colors.grey.shade400, width: 0.8),
        ),
        child: Column(
          children: [
            /// Header with title
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColorsManager.mainDarkBlue.withOpacity(0.3),
                    width: 1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                medicalItem.title,
                style: AppTextStyles.font14BlueWeight700
                    .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                /// Content Column - Right side
                Expanded(
                  child: Column(
                    children: [
                      /// Date
                      Row(
                        children: [
                          Text(
                            'التاريخ :',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            medicalItem.date,
                            style: AppTextStyles.font14blackWeight400
                                .copyWith(fontSize: 14.sp),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      /// Duration
                      Row(
                        children: [
                          Text(
                            'المدة :',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            medicalItem.duration,
                            style: AppTextStyles.font14blackWeight400
                                .copyWith(fontSize: 14.sp),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      /// Severity
                      Row(
                        children: [
                          Text(
                            'شدة المرض:',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            medicalItem.severity,
                            style: AppTextStyles.font14blackWeight400
                                .copyWith(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),

                /// Arrow Icon
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: onArrowTap,
                    icon: Image.asset(
                      'assets/images/side_arrow_filled.png',
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
