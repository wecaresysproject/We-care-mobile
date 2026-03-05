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
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_detaills.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/Presentation/views/widgets/personal_genetic_diseases_data_entry_form_fields_widget.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_state.dart';

class PersonalGeneticDiseaseDataEntryView extends StatelessWidget {
  const PersonalGeneticDiseaseDataEntryView({
    super.key,
    this.personalGeneticDiseasesEditModel,
    this.editModelId,
  });
  final PersonalGeneticDiseasDetails? personalGeneticDiseasesEditModel;
  final String? editModelId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GeneticDiseasesDataEntryCubit>(
      create: (context) {
        final cubit = getIt<GeneticDiseasesDataEntryCubit>();
        if (personalGeneticDiseasesEditModel != null && editModelId != null) {
          cubit.loadIntialyPersonalGeneticDiseasesForEditing(
            personalGeneticDiseasesEditModel!,
            documentId: editModelId!,
          );
        }
        cubit.initialDataEntryRequests();
        return cubit;
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
                    BlocBuilder<GeneticDiseasesDataEntryCubit,
                        GeneticDiseasesDataEntryState>(
                      buildWhen: (previous, current) {
                        return previous.moduleGuidanceData !=
                            current.moduleGuidanceData;
                      },
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
                            horizontalSpacing(8),
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
                                        title: "القياسات الحيوية",
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
                    PersonalGeneticDiseasesDataEntryFormFieldsWidget(),
                  ],
                ),
              ),
            ),
            // Floating button at bottom-left
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.1,
              left: 16.w,
              child: SmartAssistantButton(
                title: 'مساعد ذكي',
                subtitle: 'ابن سهل البلخي',
                imagePath: "assets/images/genetic_dissease_module.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
