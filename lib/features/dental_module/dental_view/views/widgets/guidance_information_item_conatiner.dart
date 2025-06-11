import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class GuidanceInformationItemWidget extends StatelessWidget {
  const GuidanceInformationItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and title row
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade700,
                size: 24,
              ),
              SizedBox(width: 4.w),
              Text(
                'ملاحظة حول اتجاه الصورة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),
            ],
          ),

          verticalSpacing(4),
          // Description text
          Text(
            'الصورة التوضيحية للأسنان من منظور الطبيب المعالج، '
            'لذا فإن مواضع الأسنان تظهر بشكل معكوس أفقيًا. '
            'يرجى الانتباه: السن الذي يظهر على يسار الصورة في الواقع '
            'في الجهة اليمنى من فمك والعكس صحيح.',
            style: AppTextStyles.font14blackWeight400.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.6,
            ),
            maxLines: 7,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
