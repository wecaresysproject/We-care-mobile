import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

import '../widgets/quality_of_life_app_bar.dart';

class QualityOfLifeMainView extends StatelessWidget {
  const QualityOfLifeMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const QualityOfLifeAppBar(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            _buildDataEntrySection(context),
            verticalSpacing(24),
            _buildDataViewSection(context),
            verticalSpacing(40),
          ],
        ),
      ),
    );
  }

  Widget _buildDataEntrySection(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, Routes.qualityOfLifeQuestionsView),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColorsManager.mainDarkBlue,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColorsManager.mainDarkBlue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_task, color: Colors.white, size: 24.sp),
            ),
            horizontalSpacing(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "إدخال بيانات جديدة",
                    style: AppTextStyles.font14whiteWeight600,
                  ),
                  Text(
                    "أجب على الأسئلة لتقييم جودة حياتك",
                    style: AppTextStyles.font14whiteWeight600.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildDataViewSection(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.qualityOfLifeTableView),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColorsManager.mainDarkBlue.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.description_outlined,
                  color: AppColorsManager.mainDarkBlue, size: 24.sp),
            ),
            horizontalSpacing(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "عرض السجلات والتقارير",
                    style: AppTextStyles.font14BlueWeight700,
                  ),
                  Text(
                    "راجع تقييماتك السابقة وجودة حياتك",
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      color: AppColorsManager.mainDarkBlue.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: AppColorsManager.mainDarkBlue, size: 18.sp),
          ],
        ),
      ),
    );
  }
}
