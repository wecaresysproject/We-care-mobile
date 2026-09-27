import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/monthly_examination_target/logic/cubit/monthly_examination_target_cubit.dart';
import 'package:we_care/features/doctor/shared/widgets/app_section_container_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// "الهدف الشهري" card: an [AppSectionContainerWidget] header (icon + title
/// + subtitle) followed by a value+unit dropdown-style selector — mirrors
/// [DailyBookingsLimitSectionWidget]'s `UserSelectionContainer` pattern —
/// that opens a bottom sheet with the goal-count options.
class MonthlyGoalSelectorCardWidget extends StatelessWidget {
  const MonthlyGoalSelectorCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return AppSectionContainerWidget(
      icon: Icons.flag_outlined,
      title: localization.monthlyExaminationTargetFormGoalSectionTitle,
      subtitle: localization.monthlyExaminationTargetFormGoalSectionSubtitle,
      badgeBackgroundColor: AppColorsManager.basicDataVioletBadgeBackground,
      badgeIconColor: AppColorsManager.basicDataVioletBadgeIcon,
      child: BlocSelector<MonthlyExaminationTargetCubit,
          MonthlyExaminationTargetState, int>(
        selector: (state) => state.selectedGoalCount,
        builder: (context, selectedGoalCount) {
          final unit = localization.monthlyExaminationTargetFormGoalUnit;

          return Align(
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox(
              width: 140.w,
              child: UserSelectionContainer(
                containerHintText: '$selectedGoalCount $unit',
                initialValue: '$selectedGoalCount $unit',
                options: [
                  for (final option
                      in MonthlyExaminationTargetCubit.goalCountOptions)
                    '$option $unit',
                ],
                bottomSheetTitle:
                    localization.monthlyExaminationTargetFormChooseGoal,
                searchHintText:
                    localization.monthlyExaminationTargetFormChooseGoal,
                onOptionSelected: (selected) {
                  final value = int.parse(selected.split(' ').first);
                  context
                      .read<MonthlyExaminationTargetCubit>()
                      .updateSelectedGoalCount(value);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
