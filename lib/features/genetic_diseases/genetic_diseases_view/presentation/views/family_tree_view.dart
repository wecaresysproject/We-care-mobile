import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_action_button_widget.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/genetic_diseases/data/models/get_family_members_names.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_state.dart';

class FamilyTreeView extends StatelessWidget {
  const FamilyTreeView({super.key});

  Widget buildStaticItem(BuildContext context, String title, String emoji) {
    return GestureDetector(
      onDoubleTap: () async {
        await navigateToNextScreen(context);
      },
      child: Container(
        width: 80,
        height: 50,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.h),
        decoration: BoxDecoration(
          color: Color(0xff547792),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
            ),
            horizontalSpacing(
              4.w,
            ),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: Color(0xffFEFEFE),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMainItem(
      BuildContext context, String title, String emoji, Color color) {
    return GestureDetector(
      onDoubleTap: () async {
        await navigateToNextScreen(context);
      },
      child: Container(
        width: double.infinity,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          "$emoji\n$title",
          textAlign: TextAlign.center,
          style: AppTextStyles.font18blackWight500.copyWith(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Future<void> navigateToNextScreen(BuildContext context) async {
    await context.pushNamed(Routes.familyMemberGeneticDiseases);
  }

  Widget buildRelativeItem(
      BuildContext context, String title, String emoji, Color color) {
    return GestureDetector(
      onDoubleTap: () async {
        await navigateToNextScreen(context);
      },
      child: Container(
        width: 73.5.w,
        height: 47.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "$emoji\n$title",
          textAlign: TextAlign.center,
          style: AppTextStyles.font18blackWight500.copyWith(
            color: Color(0xffFEFEFE),
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildScrollableList(List<Map<String, String>> relatives, Color color) {
    return Expanded(
      child: ListView.builder(
        itemCount: relatives.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 2.h, top: 16.h),
            child: buildRelativeItem(
              context,
              relatives[index]['title']!,
              relatives[index]['emoji']!,
              color,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<GeneticsDiseasesViewCubit>()..getFamilyMembersNames(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: Column(
            children: [
              FamilyTreeViewCustomAppBar(),
              verticalSpacing(24),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 100.w,
                  height: 35.h,
                  child: CustomActionButton(
                    onTap: () {},
                    title: 'تعديل',
                    icon: 'assets/images/edit.png',
                  ),
                ),
              ),
              verticalSpacing(20),
              Text(
                "“عند الضغط على أحد الأقارب تظهر جميع التفاصيل ”",
                textAlign: TextAlign.center,
                style: AppTextStyles.font20blackWeight600.copyWith(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              verticalSpacing(40),
              BlocBuilder<GeneticsDiseasesViewCubit,GeneticsDiseasesViewState>(
                builder: (context, state) {
                  if (state.requestStatus == RequestStatus.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.requestStatus == RequestStatus.failure) {
                    return Center(
                      child: Text(
                        state.message ?? "حدث خطأ ما",
                        style: AppTextStyles.font18blackWight500.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  return Row(
                    children: [
                      /// الجهة اليمنى (الأب)
                      buildFatherRelativesPart(context,state.familyMembersNames),

                      horizontalSpacing(16),

                      /// الجهة اليسرى (الأم)
                     buildMotherRelativesPart(context,state.familyMembersNames),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildFatherRelativesPart(BuildContext context,GetFamilyMembersNames? familyMembersNames) {
    final paternalGrandfather = familyMembersNames!.grandpaFather!.first ;
    final paternalGrandmother =  familyMembersNames.grandmaFather!.first ;
    final father = familyMembersNames.father!.first;
    final brothers = familyMembersNames.bro ?? ["أخ"];
    final paternalUncles = familyMembersNames.fatherSideUncle ?? ["عم"];
    final paternalAunts = familyMembersNames.fatherSideAunt ?? ["عمة"];

    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildStaticItem(context, paternalGrandfather, "👴🏻"),
              horizontalSpacing(16),
              buildStaticItem(context, paternalGrandmother, "👵🏻"),
            ],
          ),
          verticalSpacing(16),
          buildMainItem(
              context, father, "🧔🏻‍♂️", AppColorsManager.mainDarkBlue),
          verticalSpacing(16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: brothers.map((brother) {
              return buildRelativeItem(
                  context, brother, "👦🏻", const Color(0xff99CBE9));
            }).toList(),
          ),
          verticalSpacing(12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              ...paternalUncles.map((uncle) => buildRelativeItem(
                  context, uncle, "👨🏻‍🦱",Color(0xff5A4B8D))),
              ...paternalAunts.map((aunt) => buildRelativeItem(
                  context, aunt, "👩🏻‍🦱",Color(0xff5A4B8D))),
            ],
          ),
        ],
      ),
    );
  }

  Expanded buildMotherRelativesPart(BuildContext context,GetFamilyMembersNames? familyMembersNames) {
    final maternalGrandfather = familyMembersNames!.grandpaMother!.first;
    final maternalGrandmother = familyMembersNames.grandmaMother!.first;
    final mother = familyMembersNames.mother!.first;
    final sisters = familyMembersNames.sis ?? ["أخت"];
    final maternalUncles = familyMembersNames.motherSideUncle ?? ["خال"];
    final maternalAunts = familyMembersNames.motherSideAunt ?? ["خالة"];

    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildStaticItem(context, maternalGrandfather, "👴🏻"),
              horizontalSpacing(16),
              buildStaticItem(context, maternalGrandmother, "👵🏻"),
            ],
          ),
          verticalSpacing(16),
          buildMainItem(
              context, mother, "👩🏻‍🦳", AppColorsManager.mainDarkBlue),
          verticalSpacing(16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: sisters.map((sister) {
              return buildRelativeItem(
                  context, sister, "👩🏻", Colors.lightBlue[100]!);
            }).toList(),
          ),
          verticalSpacing(12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              ...maternalUncles.map((uncle) => buildRelativeItem(
                  context, uncle, "👨🏻‍🦱", Color(0xff5A4B8D))),
              ...maternalAunts.map((aunt) => buildRelativeItem(
                  context, aunt, "👩🏻‍🦱",Color(0xff5A4B8D))),
            ],
          ),
        ],
      ),
    );
  }
}

class FamilyTreeViewCustomAppBar extends StatelessWidget {
  const FamilyTreeViewCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Back arrow on the left
        CustomBackArrow(),

        // Manually spaced center text
        SizedBox(
          width: MediaQuery.of(context).size.width *
              0.25, // Adjust this width as needed
        ), // Adjust this width as needed
        Text(
          "شجرة العائلة",
          textAlign: TextAlign.center,
          style: AppTextStyles.font18blackWight500.copyWith(
            color: AppColorsManager.textColor,
          ),
        ),

        // Spacer to push the row to the right end
        Spacer(),
      ],
    );
  }
}
