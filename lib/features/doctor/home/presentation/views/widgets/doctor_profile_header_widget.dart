import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/home/data/doctor_home_placeholder_content.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_profile_summary_model.dart';
import 'package:we_care/features/doctor/home/logic/cubit/doctor_home_cubit.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_avatar_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_home_section_shimmers.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_menu_button_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/home_section_error_widget.dart';

/// Clinic logo, the doctor's name/specialty/photo, and the overflow menu. Only
/// the identity block depends on the profile request — the logo and the menu
/// (which holds logout) stay usable while it loads or fails.
class DoctorProfileHeaderWidget extends StatelessWidget {
  const DoctorProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 72.w,
            height: 44.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColorsManager.placeHolderColor, width: 0.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            // Figma fills this box edge-to-edge with the logo scaled up
            // (cover), not fitted-with-padding — matches BoxFit.cover here.
            child: Image.asset(
              DoctorHomePlaceholderContent.clinicLogoAsset,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
                buildWhen: (previous, current) =>
                    previous.profile != current.profile ||
                    previous.profileStatus != current.profileStatus,
                builder: (context, state) => HomeSectionStateWidget(
                  data: state.profile,
                  isFailure: state.profileStatus == RequestStatus.failure,
                  shimmer: const DoctorProfileIdentityShimmer(),
                  error: HomeSectionErrorWidget(
                    compact: true,
                    onRetry: () =>
                        context.read<DoctorHomeCubit>().getProfileSummary(),
                  ),
                  builder: (profile) => _DoctorIdentity(profile: profile),
                ),
              ),
              const DoctorMenuButtonWidget(),
            ],
          ),
        ],
      ),
    );
  }
}

class _DoctorIdentity extends StatelessWidget {
  const _DoctorIdentity({required this.profile});

  final DoctorProfileSummaryModel profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              profile.displayName,
              style: AppTextStyles.font13homeLabelWeight500.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              profile.specialty,
              style: AppTextStyles.font12blackWeight500.copyWith(
                color: AppColorsManager.homePrimaryBlue,
                height: 1.3,
              ),
            ),
          ],
        ),
        SizedBox(width: 8.w),
        DoctorAvatarWidget(
          name: profile.name,
          photoUrl: profile.profileImage,
        ),
      ],
    );
  }
}
