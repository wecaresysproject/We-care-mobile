import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// شاشة مبدئية لحد ما يتم تنفيذ تفاصيل كل قسم من أقسام "طبيبك أون لاين".
class OnlineDoctorPlaceholderBody extends StatelessWidget {
  const OnlineDoctorPlaceholderBody({
    super.key,
    required this.imagePath,
    required this.message,
  });

  final String imagePath;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96.w,
            height: 96.h,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFCDE1F8), Color(0xFFE7E9EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          verticalSpacing(16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16BlackSemiBold.copyWith(
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
          verticalSpacing(8),
          Text(
            "قريباً",
            style: AppTextStyles.font14blackWeight400.copyWith(
              color: AppColorsManager.placeHolderColor,
            ),
          ),
        ],
      ),
    );
  }
}
