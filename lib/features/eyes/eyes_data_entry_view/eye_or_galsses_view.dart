import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/widgets/custom_image_with_text_eye_module_widget.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/widgets/eye_part_view_data_entry.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_cubit.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_state.dart';

class EyeOrGlassesView extends StatelessWidget {
  const EyeOrGlassesView({super.key, this.onGlassesTapped, this.onEyesTapped});
  final void Function()? onGlassesTapped;
  final void Function()? onEyesTapped;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EyeViewCubit>(
      create: (context) => getIt<EyeViewCubit>()..emitModuleGuidance(),
      child: Scaffold(
        body: SafeArea(
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  BlocBuilder<EyeViewCubit, EyeViewState>(
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
                                      title: "العيون",
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
                  verticalSpacing(113),
                  CustomImageWithTextEyeModuleWidget(
                    onTap: onEyesTapped ??
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => getIt<EyeViewCubit>()
                                  ..getEffectedEyeParts(),
                                child: EyePartsViewDataEntry(
                                  isDataEntryPage: true,
                                  pageTitle:
                                      'اضغط على جزء العين الذى تشتكى منه',
                                  handleArrowTap: (partName) async {
                                    await context.pushNamed(
                                      Routes.eyeProceduresAndSyptomsDataEntry,
                                      arguments: {
                                        'eyePart': partName,
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                    imagePath:
                        "assets/images/eye_information_data_entry_image.png",
                    text: "بيانات العيون",
                    textStyle: AppTextStyles.font22WhiteWeight600.copyWith(
                      fontSize: 24.sp,
                    ),
                    isTextFirst: true,
                  ),
                  verticalSpacing(88),
                  CustomImageWithTextEyeModuleWidget(
                    onTap: onGlassesTapped ??
                        () {
                          Navigator.pushNamed(
                            context,
                            Routes.glassesInformationDataEntryView,
                          );
                        },
                    imagePath:
                        "assets/images/glasses_informations_data_entry_image.png",
                    text: "بيانات النظارة",
                    textStyle: AppTextStyles.font22WhiteWeight600.copyWith(
                      fontSize: 24.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
