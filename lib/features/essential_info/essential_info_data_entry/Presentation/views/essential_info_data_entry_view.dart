import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/essential_info/data/models/get_user_essential_info_response_model.dart';
import 'package:we_care/features/essential_info/essential_info_data_entry/Presentation/views/essential_info_data_entry_form_feild.dart';
import 'package:we_care/features/essential_info/essential_info_data_entry/logic/cubit/essential_data_entry_cubit.dart';

class EssentialDataEntryView extends StatelessWidget {
  const EssentialDataEntryView({
    super.key,
    this.editingModel,
  });
  final UserEssentialInfoData? editingModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EssentialDataEntryCubit>(
      create: (context) {
        final cubit = getIt<EssentialDataEntryCubit>();
        if (editingModel != null) {
          return cubit..loadUserPersonalDetailsDataForEditing(editingModel!);
        } else {
          return cubit..initialRequests();
        }
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
                BlocBuilder<EssentialDataEntryCubit, EssentialDataEntryState>(
                  buildWhen: (previous, current) =>
                      previous.moduleGuidanceData != current.moduleGuidanceData,
                  builder: (context, state) {
                    return AppBarWithImageAndActionButtons(
                      haveBackArrow: true,
                      trailingActions: [
                        CircleIconButton(
                          icon: Icons.play_arrow,
                          color:
                              state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                      true
                                  ? AppColorsManager.mainDarkBlue
                                  : Colors.grey,
                          onTap:
                              state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                      true
                                  ? () => launchYouTubeVideo(
                                      state.moduleGuidanceData!.videoLink)
                                  : null,
                        ),
                        SizedBox(width: 8.w),
                        CircleIconButton(
                          icon: Icons.menu_book_outlined,
                          color: state.moduleGuidanceData?.moduleGuidanceText
                                      ?.isNotEmpty ==
                                  true
                              ? AppColorsManager.mainDarkBlue
                              : Colors.grey,
                          onTap: state.moduleGuidanceData?.moduleGuidanceText
                                      ?.isNotEmpty ==
                                  true
                              ? () {
                                  ModuleGuidanceAlertDialog.show(
                                    context,
                                    title: "البيانات الأساسية",
                                    description: state.moduleGuidanceData!
                                        .moduleGuidanceText!,
                                  );
                                }
                              : null,
                        ),
                      ],
                    );
                  },
                ),
                verticalSpacing(24),
                EssentialDataEntryFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
