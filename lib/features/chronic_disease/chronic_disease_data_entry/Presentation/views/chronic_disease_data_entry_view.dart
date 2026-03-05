import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/SharedWidgets/smart_assistant_button_shared_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_data_entry/Presentation/views/widgets/chronic_disease_data_entry_form_fields_widget.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_data_entry/logic/cubit/chronic_disease_data_entry_cubit.dart';
import 'package:we_care/features/chronic_disease/data/models/post_chronic_disease_model.dart';

class ChronicDiseaseDataEntryView extends StatelessWidget {
  const ChronicDiseaseDataEntryView({
    super.key,
    this.editModel,
    this.documentId,
  });
  final PostChronicDiseaseModel? editModel;
  final String? documentId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChronicDiseaseDataEntryCubit>(
      create: (context) {
        var cubit = getIt<ChronicDiseaseDataEntryCubit>();
        if (editModel != null) {
          return cubit
            ..loadChronicDiseaseDataForEditing(editModel!, documentId!);
        }
        return cubit..intialRequests();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<ChronicDiseaseDataEntryCubit,
                        ChronicDiseaseDataEntryState>(
                      buildWhen: (previous, current) =>
                          previous.moduleGuidanceData !=
                          current.moduleGuidanceData,
                      builder: (context, state) {
                        return AppBarWithImageAndActionButtons(
                          haveBackArrow: true,
                          trailingActions: [
                            CircleIconButton(
                              icon: Icons.play_arrow,
                              color: state.moduleGuidanceData?.videoLink
                                          ?.isNotEmpty ==
                                      true
                                  ? AppColorsManager.mainDarkBlue
                                  : Colors.grey,
                              onTap: state.moduleGuidanceData?.videoLink
                                          ?.isNotEmpty ==
                                      true
                                  ? () => launchYouTubeVideo(
                                      state.moduleGuidanceData!.videoLink)
                                  : null,
                            ),
                            SizedBox(width: 8.w),
                            CircleIconButton(
                              icon: Icons.menu_book_outlined,
                              color: state.moduleGuidanceData
                                          ?.moduleGuidanceText?.isNotEmpty ==
                                      true
                                  ? AppColorsManager.mainDarkBlue
                                  : Colors.grey,
                              onTap: state.moduleGuidanceData
                                          ?.moduleGuidanceText?.isNotEmpty ==
                                      true
                                  ? () {
                                      ModuleGuidanceAlertDialog.show(
                                        context,
                                        title: "الأمراض المزمنة",
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
                    ChronicDiseaseDataEntryFormFields(),
                  ],
                ),
              ),
            ),
            // Floating button at bottom-left
            Positioned(
              bottom: 5.h,
              left: 16.w,
              child: SmartAssistantButton(
                title: 'مساعد ذكي',
                subtitle: 'هوا تو',
                imagePath: "assets/images/chronic_disease_module_agent.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
