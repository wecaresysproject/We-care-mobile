import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/mental_illness_data_entry_form_fields_widget.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/logic/cubit/mental_illnesses_data_entry_cubit.dart';

class MentalIllnessDataEntry extends StatelessWidget {
  const MentalIllnessDataEntry({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicalIllnessesDataEntryCubit>(
      create: (context) {
        return getIt<MedicalIllnessesDataEntryCubit>()..initialRequests();
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
                BlocBuilder<MedicalIllnessesDataEntryCubit,
                    MedicalIllnessesDataEntryState>(
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
                          onTap: () {
                            if (state.moduleGuidanceData?.videoLink
                                    ?.isNotEmpty ==
                                true) {
                              launchYouTubeVideo(
                                  state.moduleGuidanceData!.videoLink!);
                            }
                          },
                        ),
                        horizontalSpacing(8),
                        CircleIconButton(
                          icon: Icons.menu_book_outlined,
                          color: state.moduleGuidanceData?.moduleGuidanceText
                                      ?.isNotEmpty ==
                                  true
                              ? AppColorsManager.mainDarkBlue
                              : Colors.grey,
                          onTap: () {
                            if (state.moduleGuidanceData?.moduleGuidanceText
                                    ?.isNotEmpty ==
                                true) {
                              showDialog(
                                context: context,
                                builder: (context) => ModuleGuidanceAlertDialog(
                                  title: "إرشادات",
                                  description: state
                                      .moduleGuidanceData!.moduleGuidanceText!,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                verticalSpacing(24),
                MentalIlnessesDataEntryFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
