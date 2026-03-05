import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_cubit.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_state.dart';
import 'package:we_care/features/dental_module/dental_view/views/tooth_anatomy_view.dart';

class DentalAnatomyDiagramEntryView extends StatelessWidget {
  const DentalAnatomyDiagramEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DentalViewCubit>(
      create: (context) => getIt<DentalViewCubit>()
        ..getDefectedTooth()
        ..emitModuleGuidance(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            children: [
              BlocBuilder<DentalViewCubit, DentalViewState>(
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
                                  title: "طب الأسنان",
                                  description: state
                                      .moduleGuidanceData!.moduleGuidanceText!,
                                );
                              }
                            : null,
                      ),
                    ],
                  ).paddingSymmetricHorizontal(16);
                },
              ),
              verticalSpacing(16),
              buildToothOverLayBlockBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildToothOverLayBlockBuilder() {
    return BlocBuilder<DentalViewCubit, DentalViewState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ToothOverlay(
          isComingFromDataEntry: true,
          toothWithDataList: state.defectedToothList ?? [],
          selectedActionsList: state.defectedToothList ?? [],
          overlayTitle: "“من فضلك اختر السن المصاب لادخال البيانات الخاصة به”",
          onTap: (tappedTooth) async {
            await context.pushNamed(
              Routes.dentalDataEntryView,
              arguments: {
                "toothNumber": tappedTooth.toString(),
              },
            );
          },
        );
      },
    );
  }
}
