// Simplified version - more readable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_dialogs.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_cubit.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_state.dart';

class SupplementsPlanActivationToggleBlocBuilder extends StatelessWidget {
  const SupplementsPlanActivationToggleBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplementsDataEntryCubit, SupplementsDataEntryState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: state.supplementFollowUpCurrentTabIndex == 0
                  ? state.weeklyActivationStatus
                  : state.monthlyActivationStatus,
              onChanged: (value) {
                final isWeeklyTab =
                    state.supplementFollowUpCurrentTabIndex == 0;
                final isMonthlyTab =
                    state.supplementFollowUpCurrentTabIndex == 1;

                AppLogger.debug(
                    'Switch toggled: value=$value, isWeeklyTab=$isWeeklyTab');
                AppLogger.debug(
                    'Current status - Weekly: ${state.weeklyActivationStatus}, Monthly: ${state.monthlyActivationStatus}');

                // Check if user is trying to ACTIVATE a plan while another is active
                if (value == true) {
                  // User wants to activate current plan
                  if (isWeeklyTab && state.monthlyActivationStatus) {
                    // Trying to activate weekly while monthly is active
                    AppLogger.debug(
                        'Blocked: Cannot activate weekly while monthly is active');
                    showWarningDialog(
                      context,
                      message: "لا يمكن تفعيل أكثر من خطة في نفس الوقت",
                    );
                    return;
                  }

                  if (isMonthlyTab && state.weeklyActivationStatus) {
                    // Trying to activate monthly while weekly is active
                    AppLogger.debug(
                        'Blocked: Cannot activate monthly while weekly is active');
                    showWarningDialog(
                      context,
                      message: "لا يمكن تفعيل أكثر من خطة في نفس الوقت",
                    );
                    return;
                  }
                }

                // If we reach here:
                // - User is deactivating (value = false) -> Always allowed
                // - User is activating but no other plan is active -> Allowed
                AppLogger.debug('Proceeding with plan toggle');
                context
                    .read<SupplementsDataEntryCubit>()
                    .togglePlanActivationAndLoadingExistingPlans();
              },
              trackOutlineColor: WidgetStateProperty.all(
                AppColorsManager.placeHolderColor.withAlpha(50),
              ),
              activeThumbColor: AppColorsManager.mainDarkBlue,
              activeTrackColor: const Color(0xffDAE9FA),
              inactiveThumbColor: AppColorsManager.placeHolderColor,
              inactiveTrackColor: Colors.grey.withAlpha(100),
            ),
            horizontalSpacing(10),
            Text(
              'تفعيل الخطة',
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ],
        );
      },
    );
  }
}
