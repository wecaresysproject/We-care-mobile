import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';
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

                Expanded(
                  child:
                      BlocBuilder<AccessManagementCubit, AccessManagementState>(
                    builder: (context, state) {
                      if (state.incomingRequestsStatus ==
                              RequestStatus.loading ||
                          state.incomingRequestsStatus ==
                              RequestStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.incomingRequestsStatus ==
                          RequestStatus.failure) {
                        return Center(
                            child: Text(state.incomingRequestsMessage));
                      }

                      final requests = state.incomingRequests?.requests ?? [];
                      final count =
                          state.incomingRequests?.pendingRequestsCount ?? 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 2. Request Status Strip
                          if (count > 0) RequestStatusStrip(count: count),

                          if (count > 0) verticalSpacing(24),

                          // 3. Requests List
                          Expanded(
                            child: requests.isEmpty
                                ? Center(
                                    child: Text(
                                      'لا توجد طلبات وصول',
                                      style:
                                          AppTextStyles.font16DarkGreyWeight400,
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: requests.length,
                                    itemBuilder: (context, index) {
                                      final request = requests[index];
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 24.h),
                                        child: CareAccessRequestCard(
                                          request: request,
                                          onReview: () {
                                            context.pushNamedWithSettingRootNavigator(
                                              Routes.reviewCareAccessRequestView,
                                              arguments: request.requestId,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
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
