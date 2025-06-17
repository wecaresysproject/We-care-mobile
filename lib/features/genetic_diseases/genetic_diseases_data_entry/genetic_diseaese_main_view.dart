import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_state.dart';

class GeneticDiseaeseMainView extends StatelessWidget {
  const GeneticDiseaeseMainView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GeneticDiseasesDataEntryCubit>(
      create: (context) => getIt<GeneticDiseasesDataEntryCubit>()
        ..getIsFirstTimeAnsweredFamilyMembersQuestions(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBarWidget(
                  haveBackArrow: true,
                ),
                verticalSpacing(130),
                BlocBuilder<GeneticDiseasesDataEntryCubit,
                    GeneticDiseasesDataEntryState>(
                  builder: (context, state) {
                    return GenticDiseaseButtonCard(
                      isDisabled:
                          state.isFirstTimeAnsweringFamilyMemberQuestions,
                      iconPath: 'assets/images/add_button.png',
                      title: !state.isFirstTimeAnsweringFamilyMemberQuestions
                          ? "انشاء شجرة العائلة"
                          : "للتعديل، يرجى زيارة شجرة العائلة",
                      onTap: () async {
                        await context.pushNamed(
                          Routes.numberOfFamilyMembersView,
                        );
                      },
                    );
                  },
                ),
                verticalSpacing(68),
                GenticDiseaseButtonCard(
                  iconPath: 'assets/images/add_button.png',
                  title: "الأمراض الوراثية العائلية",
                  onTap: () async {
                    await context.pushNamed(
                      Routes.familyTreeViewFromDataEntry,
                    );
                  },
                ),
                verticalSpacing(68),
                GenticDiseaseButtonCard(
                  iconPath: 'assets/images/add_button.png',
                  title: "أمراضى الوراثية",
                  onTap: () async {
                    await context.pushNamed(
                      Routes.personalGeneticDiseasesDataEnrtyView,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GenticDiseaseButtonCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback? onTap;
  final bool isDisabled;

  const GenticDiseaseButtonCard({
    super.key,
    required this.title,
    required this.iconPath,
    this.onTap,
    this.isDisabled = false, // Default false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap, // Disable tap if isDisabled
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0, // Visual indication
        child: Container(
          width: 343.w,
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColorsManager.secondaryColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    iconPath,
                    width: 24.w,
                    height: 24.h,
                  ),
                  horizontalSpacing(8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Image.asset(
                "assets/images/left_arrow_icon.png",
                width: 24.w,
                height: 24.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
