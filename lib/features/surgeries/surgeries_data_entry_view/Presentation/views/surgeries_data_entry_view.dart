import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/surgeries/data/models/get_user_surgeries_response_model.dart';
import 'package:we_care/features/surgeries/surgeries_data_entry_view/logic/cubit/surgery_data_entry_cubit.dart';

import 'widgets/surgeries_data_form_fields_widget.dart';

class SurgeriesDataEntryView extends StatelessWidget {
  const SurgeriesDataEntryView({super.key, this.existingSurgeryModel});
  final SurgeryModel? existingSurgeryModel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SurgeryDataEntryCubit>(
      create: (context) {
        var cubit = getIt<SurgeryDataEntryCubit>();
        if (existingSurgeryModel != null) {
          cubit.loadPastSurgeryDataForEditing(existingSurgeryModel!);
        } else {
          cubit.intialRequestsForDataEntry();
        }
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<SurgeryDataEntryCubit, SurgeryDataEntryState>(
                  buildWhen: (previous, current) =>
                      previous.moduleGuidanceData != current.moduleGuidanceData,
                  builder: (context, state) {
                    final guidance = state.moduleGuidanceData;
                    final hasVideo = guidance?.videoLink?.isNotEmpty == true;
                    final hasText =
                        guidance?.moduleGuidanceText?.isNotEmpty == true;

                    return AppBarWithImageAndActionButtons(
                      haveBackArrow: true,
                      trailingActions: [
                        CircleIconButton(
                          icon: Icons.play_arrow,
                          color: hasVideo
                              ? AppColorsManager.mainDarkBlue
                              : Colors.grey,
                          onTap: hasVideo
                              ? () => launchYouTubeVideo(guidance!.videoLink)
                              : null,
                        ),
                        SizedBox(width: 8.w),
                        CircleIconButton(
                          icon: Icons.menu_book_outlined,
                          color: hasText
                              ? AppColorsManager.mainDarkBlue
                              : Colors.grey,
                          onTap: hasText
                              ? () {
                                  ModuleGuidanceAlertDialog.show(
                                    context,
                                    title: "العمليات",
                                    description: guidance!.moduleGuidanceText!,
                                  );
                                }
                              : null,
                        ),
                      ],
                    );
                  },
                ),
                verticalSpacing(24),
                SuergeriesDataEntryFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
