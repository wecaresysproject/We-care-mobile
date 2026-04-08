import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/appbar_with_centered_title_with_guidance.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/risky_behaviors/risky_behaviors_data_entry_view/logic/cubit/risky_behaviors_data_entry_cubit.dart';
import 'package:we_care/features/risky_behaviors/risky_behaviors_data_entry_view/logic/cubit/risky_behaviors_data_entry_state.dart';

class RiskyBehaviorsDataEntryAppBar extends StatelessWidget {
  const RiskyBehaviorsDataEntryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskyBehaviorsDataEntryCubit,
        RiskyBehaviorsDataEntryState>(
      buildWhen: (previous, current) =>
          previous.moduleGuidanceData != current.moduleGuidanceData,
      builder: (context, state) {
        return CustomAppBarWithCenteredTitleWithGuidance(
          title: 'السلوكيات الخطرة',
          trailingActions: [
            CircleIconButton(
              icon: Icons.play_arrow,
              color: state.moduleGuidanceData?.videoLink?.isNotEmpty == true
                  ? AppColorsManager.mainDarkBlue
                  : Colors.grey,
              onTap: state.moduleGuidanceData?.videoLink?.isNotEmpty == true
                  ? () =>
                      launchYouTubeVideo(state.moduleGuidanceData!.videoLink)
                  : null,
            ),
            horizontalSpacing(8),
            CircleIconButton(
              icon: Icons.menu_book_outlined,
              color: state.moduleGuidanceData?.moduleGuidanceText?.isNotEmpty ==
                      true
                  ? AppColorsManager.mainDarkBlue
                  : Colors.grey,
              onTap: state.moduleGuidanceData?.moduleGuidanceText?.isNotEmpty ==
                      true
                  ? () {
                      ModuleGuidanceAlertDialog.show(
                        context,
                        description:
                            state.moduleGuidanceData!.moduleGuidanceText!,
                        title: "السلوكيات الخطرة",
                      );
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}
