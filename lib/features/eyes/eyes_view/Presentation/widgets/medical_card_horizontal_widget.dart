import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MedicalItemCardHorizontal extends StatelessWidget {
  final String date;
  final List<String>? procedures;
  final List<String>? symptoms;
  final VoidCallback? onArrowTap;

  const MedicalItemCardHorizontal({
    super.key,
    required this.date,
    this.procedures,
    this.symptoms,
    this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onArrowTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Date Header
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 32.w,
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColorsManager.mainDarkBlue),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  date,
                  style: AppTextStyles.font14BlueWeight700
                      .copyWith(fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 10.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Column with procedures and symptoms (expanded to take space)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// الإجراءات الطبية
                      if (procedures != null && procedures!.isNotEmpty) ...[
                        Text(
                          'الإجراءات الطبية :',
                          textAlign: TextAlign.start,
                          style: AppTextStyles.font14BlueWeight700
                              .copyWith(fontSize: 14.sp),
                        ),
                        ...procedures!.asMap().entries.map((entry) => Padding(
                              padding: EdgeInsets.only(right: 12.w, top: 2.h),
                              child: Text(
                                '${entry.key + 1}/ ${entry.value}',
                                style: AppTextStyles.font14blackWeight400,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            )),
                        SizedBox(height: 8.h),
                      ],

                      /// الأعراض المرضية
                      if (symptoms != null && symptoms!.isNotEmpty) ...[
                        Text(
                          'الأعراض المرضية :',
                          style: AppTextStyles.font14BlueWeight700
                              .copyWith(fontSize: 14.sp),
                        ),
                        ...symptoms!.asMap().entries.map((entry) => Padding(
                              padding: EdgeInsets.only(right: 12.w, top: 2.h),
                              child: Text(
                                '${entry.key + 1}/ ${entry.value}',
                                style: AppTextStyles.font14blackWeight400,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            )),
                      ],
                    ],
                  ),
                ),

                /// Arrow Icon
                IconButton(
                  onPressed: onArrowTap,
                  icon: Image.asset(
                    'assets/images/side_arrow_filled.png',
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
