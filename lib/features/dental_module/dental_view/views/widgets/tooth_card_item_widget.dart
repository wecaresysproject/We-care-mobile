import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/dental_module/data/models/get_tooth_documents_reponse_model.dart';

class ToothCardItemWidget extends StatelessWidget {
  final ToothDocument item;
  final VoidCallback? onArrowTap;

  const ToothCardItemWidget({
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
                'السن ${item.teethNumber}',
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
                            'السن :',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            item.teethNumber!,
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
                            'تاريخ الأعراض:',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            item.symptomStartDate!,
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
                            "الإجراء الطبي:",
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              item.primaryProcedure!,
                              style:
                                  AppTextStyles.font14blackWeight400.copyWith(
                                fontSize: 14.sp,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      Row(
                        children: [
                          Text(
                            "نوع الألم:",
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              item.painNature!,
                              style:
                                  AppTextStyles.font14blackWeight400.copyWith(
                                fontSize: 14.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
