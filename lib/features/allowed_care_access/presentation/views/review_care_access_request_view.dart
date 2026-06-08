import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/info_banner.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/permission_explanation_card.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/permission_selection_section.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/request_details_card.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/review_request_profile_header.dart';

class ReviewCareAccessRequestScreen extends StatelessWidget {
  const ReviewCareAccessRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const ReviewRequestProfileHeader(),
                verticalSpacing(24),
                // Details Card
                const RequestDetailsCard(),
                verticalSpacing(24),
                // Permission Explanation Card
                const PermissionExplanationCard(),
                verticalSpacing(24),
                // Permission Selection Section (reuse existing widget)
                const PermissionSelectionSection(),
                verticalSpacing(24),
                // Information Banner
                const InfoBanner(
                  text: 'يمكنك تغيير الصلاحية أو إلغاء الوصول في أي وقت.',
                ),
                verticalSpacing(32),
                // Bottom Actions
                Row(
                  children: [
                    Expanded(
                      child: AppCustomButton(
                        title: 'قبول الطلب ✓',
                        isEnabled: true,
                        onPressed: () {},
                        textFontSize: 18,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppCustomButton(
                        title: 'رفض',
                        isEnabled: true,
                        onPressed: () {},
                        textFontSize: 18,
                      ),
                    ),
                  ],
                ),
                verticalSpacing(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
