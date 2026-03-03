import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/appbar_with_centered_title_with_guidance.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_state.dart';

class GeneticDiseasesHomeScreen extends StatelessWidget {
  const GeneticDiseasesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GeneticsDiseasesViewCubit>(
      create: (context) =>
          getIt<GeneticsDiseasesViewCubit>()..emitModuleGuidance(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<GeneticsDiseasesViewCubit, GeneticsDiseasesViewState>(
                buildWhen: (previous, current) =>
                    previous.moduleGuidanceData != current.moduleGuidanceData,
                builder: (context, state) {
                  final guidance = state.moduleGuidanceData;
                  final hasVideo = guidance?.videoLink?.isNotEmpty == true;
                  final hasText =
                      guidance?.moduleGuidanceText?.isNotEmpty == true;

                  return CustomAppBarWithCenteredTitleWithGuidance(
                    title: 'الامراض الوراثية',
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
                      SizedBox(width: 6.w),
                      CircleIconButton(
                        icon: Icons.menu_book_outlined,
                        color: hasText
                            ? AppColorsManager.mainDarkBlue
                            : Colors.grey,
                        onTap: hasText
                            ? () {
                                ModuleGuidanceAlertDialog.show(
                                  context,
                                  title: "الأمراض الوراثية",
                                  description: guidance!.moduleGuidanceText!,
                                );
                              }
                            : null,
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),

              // Family Tree Button
              CustomButton(
                title: 'شجرة العائلة',
                image: 'assets/images/family_tree_icon.png',
                onTap: () {
                  Navigator.pushNamed(context, Routes.familyTreeScreen);
                },
              ),

              // Genetic Diseases Button
              CustomButton(
                title: 'امراضي الوراثية',
                image: 'assets/images/dna_icon.png',
                onTap: () {
                  Navigator.pushNamed(
                      context, Routes.personalGeneticDiseasesScreen);
                },
              ),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });
  final String title;
  final String image;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        height: 140,
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          color: AppColorsManager.mainDarkBlue,
          borderRadius: BorderRadius.circular(88),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                horizontalSpacing(40),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    image,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
