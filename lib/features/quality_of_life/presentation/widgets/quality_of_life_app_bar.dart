import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/appbar_with_centered_title_with_guidance.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/quality_of_life/logic/quality_of_life_cubit.dart';
import 'package:we_care/features/quality_of_life/logic/quality_of_life_state.dart';

class QualityOfLifeAppBar extends StatelessWidget {
  const QualityOfLifeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QualityOfLifeCubit, QualityOfLifeState>(
      buildWhen: (previous, current) =>
          previous.moduleGuidanceData != current.moduleGuidanceData,
      builder: (context, state) {
        return CustomAppBarWithCenteredTitleWithGuidance(
          title: 'جودة الحياة',
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
                        title: "جودة الحياة",
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
