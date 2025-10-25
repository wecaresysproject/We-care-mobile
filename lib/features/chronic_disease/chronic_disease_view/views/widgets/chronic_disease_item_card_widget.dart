import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/chronic_disease/data/models/chronic_disease_model.dart';

class ChronicDiseaseItemCardHorizontalWidget extends StatelessWidget {
  final ChronicDiseaseModel item;
  final VoidCallback? onArrowTap;

  const ChronicDiseaseItemCardHorizontalWidget({
    super.key,
    required this.item,
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
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
          border: Border.all(color: Colors.grey.shade400, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColorsManager.mainDarkBlue.withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                item.title,
                style: AppTextStyles.font14BlueWeight700.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 12.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Content column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Diagnosis Date
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تاريخ بداية التشخيص : ',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          Expanded(
                            child: Text(
                              item.diagnosisStartDate,
                              style: AppTextStyles.font14blackWeight400
                                  .copyWith(fontSize: 14.sp),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      /// Doctor Name
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الطبيب المتابع : ',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          Expanded(
                            child: Text(
                              item.treatingDoctorName,
                              style: AppTextStyles.font14blackWeight400
                                  .copyWith(fontSize: 14.sp),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      /// Disease Status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'حالة المرض : ',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          Expanded(
                            child: Text(
                              item.diseaseStatus,
                              style: AppTextStyles.font14blackWeight400
                                  .copyWith(fontSize: 14.sp),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                /// Arrow
                Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                    onPressed: onArrowTap,
                    icon: Image.asset(
                      'assets/images/side_arrow_filled.png',
                      width: 20.w,
                      height: 20.h,
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
}
