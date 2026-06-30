import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_profile.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/add_care_person_button.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/allowed_care_access_header.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/allowed_care_access_list_view.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/care_access_requests_banner.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/who_can_access_my_record_nav_card.dart';

class AllowedCareAccessScreen extends StatefulWidget {
  const AllowedCareAccessScreen({super.key});

  @override
  State<AllowedCareAccessScreen> createState() =>
      _AllowedCareAccessScreenState();
}

class _AllowedCareAccessScreenState extends State<AllowedCareAccessScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AccessManagementCubit>().getAllowedCareAccessList();
  }

  List<CareProfile> _mapProfiles(AccessManagementState state) {
    if (state.allowedCareAccessStatus == RequestStatus.success &&
        state.allowedCareAccessList != null) {
      return state.allowedCareAccessList!.profiles.map((profile) {
        return CareProfile(
          id: profile.accessId,
          patientId: profile.patientId,
          name: profile.patientName,
          personalPhotoUrl: profile.personalPhotoUrl ?? "",
          relation: profile.relation,
          modulePermissions: profile.modulePermissions,
          addedAtLabel: profile.joinedAt,
        );
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context
                .read<AccessManagementCubit>()
                .getAllowedCareAccessList();
          },
          child: BlocBuilder<AccessManagementCubit, AccessManagementState>(
            builder: (context, state) {
              final response = state.allowedCareAccessList;
              final int pendingRequests = response?.pendingRequests ?? 0;

              final profiles = _mapProfiles(state);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AllowedCareAccessHeader(
                      title: 'قائمة المسموح بالرعاية',
                      subtitle: 'الوصول المأذون لملفاتهم الطبية',
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    verticalSpacing(20),
                    CareAccessRequestsBanner(
                      pendingRequests: pendingRequests,
                      onTap: () {
                        context.pushNamedWithSettingRootNavigator(
                            Routes.careAccessRequestsView);
                      },
                    ),
                    verticalSpacing(16),
                    WhoCanAccessMyRecordNavCard(
                      onTap: () {
                        context.pushNamedWithSettingRootNavigator(
                            Routes.whoCanAccessMyRecordView);
                      },
                    ),
                    verticalSpacing(24),
                    Divider(
                        height: 1,
                        color: (AppColorsManager.mainDarkBlue).withAlpha(150)),
                    verticalSpacing(24),
                    Text(
                      'الأشخاص المضافون تحت رعايتي',
                      style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                        color: AppColorsManager.mainDarkBlue,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    verticalSpacing(12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AllowedCareAccessListView(
                                state: state,
                                profiles: profiles,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpacing(16),
                    const AddCarePersonButton(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
