import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_profile.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/add_care_person_button.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/care_access_requests_banner.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/care_profile_card.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/care_stats_section.dart';

class AllowedCareAccessScreen extends StatefulWidget {
  const AllowedCareAccessScreen({super.key});

  @override
  State<AllowedCareAccessScreen> createState() =>
      _AllowedCareAccessScreenState();
}

class _AllowedCareAccessScreenState extends State<AllowedCareAccessScreen> {
  // Mock data as requested
  final List<CareProfile> mockProfiles = [
    const CareProfile(
      id: '1',
      name: 'أشرف إسماعيل',
      relation: 'أخي',
      permissionType: PermissionType.fullAccess,
      addedAtLabel: 'منذ ساعتين',
    ),
    const CareProfile(
      id: '2',
      name: 'محمد أحمد بسيوني',
      relation: 'جدي',
      permissionType: PermissionType.fullAccess,
      addedAtLabel: 'أمس',
    ),
    const CareProfile(
      id: '3',
      name: 'أسامة أشرف أمين',
      relation: 'أخي',
      permissionType: PermissionType.viewOnly,
      addedAtLabel: 'منذ 3 أيام',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    final int totalCount = mockProfiles.length;
    final int fullAccessCount = mockProfiles
        .where((p) => p.permissionType == PermissionType.fullAccess)
        .length;
    final int viewOnlyCount = mockProfiles
        .where((p) => p.permissionType == PermissionType.viewOnly)
        .length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColorsManager.mainDarkBlue,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'قائمة المسموح بالرعاية',
                        style: AppTextStyles.font22MainBlueWeight700.copyWith(
                          color: AppColorsManager.mainDarkBlue,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        'الوصول المأذون لملفاتهم الطبية',
                        style: AppTextStyles.font14blackWeight400.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 24),

              // Statistics Cards
              CareStatsSection(
                totalCount: totalCount,
                fullAccessCount: fullAccessCount,
                viewOnlyCount: viewOnlyCount,
              ),

              verticalSpacing(20),

              // Care Access Requests Banner
              CareAccessRequestsBanner(
                onTap: () {
                  context.pushNamedWithSettingRootNavigator(
                      Routes.careAccessRequestsView);
                },
              ),

              verticalSpacing(24),

              // Profiles List Title
              Text(
                'الأشخاص المضافون',
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                    fontWeight: FontWeight.w700),
              ),
              verticalSpacing(12),
              // Profiles List
              Expanded(
                child: ListView.builder(
                  itemCount: mockProfiles.length,
                  itemBuilder: (context, index) {
                    return CareProfileCard(
                      profile: mockProfiles[index],
                      onEnterPressed: () {
                        // Handle enter profile action
//                         CareContextManager.enter(
//   accessId: access.id,
//   patientId: access.patientId,
//   patientName: access.patientName,
//   permission: access.permission,
// );
                        context.pushNamed(Routes.bottomNavBar);
                      },
                    );
                  },
                ),
              ),

              verticalSpacing(16),
              // Add New Person Button
              AddCarePersonButton(),
            ],
          ),
        ),
      ),
    );
  }
}
