import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/monthly_examination_target/logic/cubit/monthly_examination_target_cubit.dart';
import 'package:we_care/features/doctor/monthly_examination_target/presentation/views/widgets/monthly_examination_target_banner_widget.dart';
import 'package:we_care/features/doctor/monthly_examination_target/presentation/views/widgets/monthly_goal_achievement_stats_widget.dart';
import 'package:we_care/features/doctor/monthly_examination_target/presentation/views/widgets/monthly_goal_info_banner_widget.dart';
import 'package:we_care/features/doctor/monthly_examination_target/presentation/views/widgets/monthly_goal_selector_card_widget.dart';
import 'package:we_care/features/doctor/monthly_examination_target/presentation/views/widgets/monthly_target_history_section_widget.dart';
import 'package:we_care/features/doctor/shared/widgets/app_doctor_profile_header_widget.dart';
import 'package:we_care/generated/l10n.dart';

class MonthlyExaminationTargetView extends StatelessWidget {
  const MonthlyExaminationTargetView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<MonthlyExaminationTargetCubit>()..loadMonthlyTargetData(),
      child: Scaffold(
        backgroundColor: AppColorsManager.scaffoldBackGroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppDoctorProfileHeaderWidget(
                  doctorName: 'د/ أحمد محمود',
                  specialty: 'استشاري جهاز مناعي',
                  doctorPhotoUrl: 'assets/images/doctor_photo.png',
                  isOnline: true,
                ),
                verticalSpacing(20),
                const MonthlyExaminationTargetBannerWidget(),
                verticalSpacing(18),
                const MonthlyGoalSelectorCardWidget(),
                verticalSpacing(18),
                const MonthlyGoalAchievementStatsWidget(),
                verticalSpacing(18),
                const MonthlyGoalInfoBannerWidget(),
                verticalSpacing(18),
                const MonthlyTargetHistorySectionWidget(),
                verticalSpacing(28),
                const _SubmitButton(),
                verticalSpacing(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MonthlyExaminationTargetCubit,
        MonthlyExaminationTargetState>(
      listenWhen: (prev, curr) =>
          curr.submissionStatus == RequestStatus.success ||
          curr.submissionStatus == RequestStatus.failure,
      buildWhen: (prev, curr) => prev.submissionStatus != curr.submissionStatus,
      listener: (context, state) async {
        if (state.submissionStatus == RequestStatus.success) {
          await showSuccess(state.message!);
          if (!context.mounted) return;
          context.pop(result: true);
        } else if (state.submissionStatus == RequestStatus.failure) {
          await showError(state.message!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<MonthlyExaminationTargetCubit>();
        return AppCustomButton(
          title: S.of(context).servicePricesFormSaveSettings,
          icon: Icons.save_outlined,
          isEnabled: state.submissionStatus != RequestStatus.loading,
          isLoading: state.submissionStatus == RequestStatus.loading,
          onPressed: cubit.saveSettings,
        );
      },
    );
  }
}
