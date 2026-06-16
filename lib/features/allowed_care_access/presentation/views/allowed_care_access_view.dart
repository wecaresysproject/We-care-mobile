import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/care_stats_section.dart';

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
          relation: profile.relation,
          permissionType: profile.permission == 'FULL_ACCESS'
              ? PermissionType.fullAccess
              : PermissionType.viewOnly,
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
              final int totalCount = response?.statistics.totalProfiles ?? 0;
              final int fullAccessCount =
                  response?.statistics.fullAccessProfiles ?? 0;
              final int viewOnlyCount =
                  response?.statistics.viewOnlyProfiles ?? 0;

              final profiles = _mapProfiles(state);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AllowedCareAccessHeader(),
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 24),
                    CareStatsSection(
                      totalCount: totalCount,
                      fullAccessCount: fullAccessCount,
                      viewOnlyCount: viewOnlyCount,
                    ),
                    verticalSpacing(20),
                    CareAccessRequestsBanner(
                      onTap: () {
                        context.pushNamedWithSettingRootNavigator(
                            Routes.careAccessRequestsView);
                      },
                    ),
                    verticalSpacing(24),
                    Text(
                      'الأشخاص المضافون',
                      style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                          color: AppColorsManager.mainDarkBlue,
                          fontWeight: FontWeight.w700),
                    ),
                    verticalSpacing(12),
                    Expanded(
                      child: AllowedCareAccessListView(
                        state: state,
                        profiles: profiles,
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
