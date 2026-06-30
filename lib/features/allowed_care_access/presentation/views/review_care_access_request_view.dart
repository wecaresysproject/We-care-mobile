import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/info_banner.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/modules_permissions_summary_card.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/permission_explanation_card.dart';
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
          child: BlocListener<AccessManagementCubit, AccessManagementState>(
            listenWhen: (previous, current) =>
                previous.approveRequestStatus != current.approveRequestStatus ||
                previous.rejectRequestStatus != current.rejectRequestStatus,
            listener: (context, state) {
              if (state.approveRequestStatus == RequestStatus.success) {
                showSuccess(state.approveRequestMessage);
                context.pop(result: true);
              } else if (state.approveRequestStatus == RequestStatus.failure) {
                showError(
                  state.approveRequestMessage,
                );
              }

              if (state.rejectRequestStatus == RequestStatus.success) {
                showSuccess(state.rejectRequestMessage);
                context.pop(result: true);
              } else if (state.rejectRequestStatus == RequestStatus.failure) {
                showError(
                  state.rejectRequestMessage,
                );
              }
            },
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 24.h),
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
                            relation: details.relation,
                          ),
                          verticalSpacing(24),
                          // Permission Explanation Card
                          PermissionExplanationCard(
                            capabilities: details.permissionCapabilities,
                          ),

                          verticalSpacing(24),
                          // Permission Selection Section (reuse existing widget)
                          // const PermissionSelectionSection(),
                          ModulesPermissionsSummaryCard(
                            onTap: () {
                              final cubit =
                                  context.read<AccessManagementCubit>();
                              cubit.initDraftPermissions();

                              context.pushNamed(
                                Routes.modulePermissionsView,
                                arguments: cubit,
                              );
                            },
                          ),
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
                                  isEnabled: state.rejectRequestStatus !=
                                      RequestStatus.loading,
                                  isLoading: state.approveRequestStatus ==
                                      RequestStatus.loading,
                                  onPressed: () {
                                    context
                                        .read<AccessManagementCubit>()
                                        .approveCareAccessRequest(
                                            widget.requestId);
                                  },
                                  textFontSize: 18,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: AppCustomButton(
                                  title: 'رفض',
                                  isEnabled: state.approveRequestStatus !=
                                      RequestStatus.loading,
                                  isLoading: state.rejectRequestStatus ==
                                      RequestStatus.loading,
                                  onPressed: () {
                                    context
                                        .read<AccessManagementCubit>()
                                        .rejectCareAccessRequest(
                                            widget.requestId);
                                  },
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
      ),
    );
  }
}
