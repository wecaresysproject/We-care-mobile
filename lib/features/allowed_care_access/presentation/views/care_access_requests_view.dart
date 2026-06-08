import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/care_access_request_card.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/care_access_requests_header.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/request_status_strip.dart';

class CareAccessRequestsScreen extends StatelessWidget {
  const CareAccessRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Sticky Header Section
                CareAccessRequestsHeader(
                  onBack: () => Navigator.of(context).pop(),
                ),

                verticalSpacing(16),

                // 2. Request Status Strip
                const RequestStatusStrip(),

                verticalSpacing(24),

                // 3. Requests List
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        1, // Only 1 static item for now as per instructions
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: CareAccessRequestCard(
                          onReview: () {
                            context.pushNamedWithSettingRootNavigator(
                                Routes.reviewCareAccessRequestView);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
