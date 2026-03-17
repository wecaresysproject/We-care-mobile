import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/appbar_with_centered_title_with_guidance.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/medical_compitability_system_prompt_view.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/medication_compitability_form_field_widget.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicationCompatibilityView extends StatelessWidget {
  const MedicationCompatibilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicinesDataEntryCubit>(
      create: (context) {
        final cubit = getIt<MedicinesDataEntryCubit>();
        cubit.initialRequestsForMedicalCompitability();
        return cubit;
      },
      child: Builder(builder: (context) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final cubit = context.read<MedicinesDataEntryCubit>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: const MedicalCompitaiblitySystemPromptView(),
                  ),
                ),
              );
            },
            backgroundColor: AppColorsManager.mainDarkBlue,
            child: const Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<MedicinesDataEntryCubit, MedicinesDataEntryState>(
                    buildWhen: (previous, current) =>
                        previous.moduleGuidanceData !=
                        current.moduleGuidanceData,
                    builder: (context, state) {
                      return CustomAppBarWithCenteredTitleWithGuidance(
                        title: 'اختبار توافق ادويتي',
                        trailingActions: [
                          CircleIconButton(
                            size: 30.w,
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
                          horizontalSpacing(8.w),
                          CircleIconButton(
                            size: 30.w,
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
                                      title: "توافق ادويتي",
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
                  MedicationCompatibilityFormFieldsWidget(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
