import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/info_banner.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/permission_explanation_card.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/permission_selection_section.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/request_details_card.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/review_request_profile_header.dart';

class ReviewCareAccessRequestScreen extends StatefulWidget {
  final String requestId;
  const ReviewCareAccessRequestScreen({super.key, required this.requestId});

  @override
  State<ReviewCareAccessRequestScreen> createState() =>
      _ReviewCareAccessRequestScreenState();
}

class _ReviewCareAccessRequestScreenState
    extends State<ReviewCareAccessRequestScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<AccessManagementCubit>()
        .getCareAccessRequestDetails(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<AccessManagementCubit, AccessManagementState>(
            builder: (context, state) {
              switch (state.requestDetailsStatus) {
                case RequestStatus.initial:
                case RequestStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case RequestStatus.failure:
                  return Center(
                    child: Text(
                      state.requestDetailsMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                case RequestStatus.success:
                  final details = state.requestDetails;
                  if (details == null) {
                    return const Center(child: Text('لا توجد تفاصيل'));
                  }

                  return SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        ReviewRequestProfileHeader(
                          requesterDetails: details.requester,
                        ),
                        verticalSpacing(24),
                        // Details Card
                        RequestDetailsCard(
                          requestedPermission: details.requestedPermission,
                          relation: details.relation,
                          requestedAt: details.requestedAt,
                        ),
                        verticalSpacing(24),
                        // Permission Explanation Card
                        PermissionExplanationCard(
                          capabilities: details.permissionCapabilities,
                        ),

                        verticalSpacing(24),
                        // Permission Selection Section (reuse existing widget)
                        const PermissionSelectionSection(),
                        verticalSpacing(24),
                        // Information Banner
                        const InfoBanner(
                          text:
                              'يمكنك تغيير الصلاحية أو إلغاء الوصول في أي وقت.',
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
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
