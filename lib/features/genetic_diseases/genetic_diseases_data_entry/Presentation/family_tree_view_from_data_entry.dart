import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/genetic_diseases/data/models/get_family_members_names.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_state.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/presentation/views/family_tree_view.dart';

class FamilyTreeViewFromDataEntry extends StatelessWidget {
  const FamilyTreeViewFromDataEntry({super.key});

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
              verticalSpacing(48),
              Text(
                "\"برجاء الضغط على القريب لكى يتم\nادخال البيانات الوراثية.\"",
                textAlign: TextAlign.center,
                style: AppTextStyles.font20blackWeight600.copyWith(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              verticalSpacing(20),
              BlocBuilder<GeneticsDiseasesViewCubit, GeneticsDiseasesViewState>(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// الجهة اليمنى (الأب)
                      buildFatherRelativesPart(
                        context,
                        state.familyMembersNames,
                      ),

                      horizontalSpacing(16),

                      /// الجهة اليسرى (الأم)
                      buildMotherRelativesPart(
                        context,
                        state.familyMembersNames,
                      ),
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

  Widget buildStaticItem(
      BuildContext context, String title, String emoji, FamilyCodes code) {
    return GestureDetector(
      onDoubleTap: () async {
        await navigateToNextScreen(context, code, title);
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: 44.25,
          maxWidth: 73.5,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
          horizontal: 8.w,
        ),
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Color(0xff547792),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
            ),
            verticalSpacing(4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title.split(" ").first,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
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
    BuildContext context,
    String title,
    String emoji,
    Color color,
    FamilyCodes code,
  ) {
    return GestureDetector(
      onDoubleTap: () async {
        await navigateToNextScreen(context, code, title);
      },
      child: Container(
        width: double.infinity,
        height: 56.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          "$emoji\n${title.split(' ').first}",
          textAlign: TextAlign.center,
          style: AppTextStyles.font18blackWight500.copyWith(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Future<void> navigateToNextScreen(
    BuildContext context,
    FamilyCodes code,
    String familyMemberName,
  ) async {
    final result = await context.pushNamed(
      Routes.familyMemeberGeneticDiseaseDataEntryView,
      arguments: {
        'memberCode': code,
        'memberName': familyMemberName,
      },
    );

    if (result == true && context.mounted) {
      await context.read<GeneticsDiseasesViewCubit>().getFamilyMembersNames();
    }
  }

  Widget buildRelativeItem(
    BuildContext context,
    String title,
    String emoji,
    Color color,
    FamilyCodes code,
  ) {
    return GestureDetector(
      onDoubleTap: () async {
        await navigateToNextScreen(context, code, title);
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
          "$emoji\n${title.split(' ').first}",
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

  Widget buildFatherRelativesPart(
      BuildContext context, GetFamilyMembersNames? familyMembersNames) {
    final paternalGrandfather = familyMembersNames!.grandpaFather!.first;
    final paternalGrandmother = familyMembersNames.grandmaFather!.first;
    final father = familyMembersNames.father!.first;
    final brothers = familyMembersNames.bro ?? ["أخ"];
    final paternalUncles = familyMembersNames.fatherSideUncle ?? ["عم"];
    final paternalAunts = familyMembersNames.fatherSideAunt ?? ["عمة"];
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BulletLabel(label: "الأجداد", color: Color(0xFF547792)),
          verticalSpacing(8),
          BulletLabel(label: "الآباء", color: Color(0xFF004B84)),
          verticalSpacing(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStaticItem(
                context,
                paternalGrandfather,
                "👴🏻",
                FamilyCodes.GrandpaFather,
              ),
              buildStaticItem(
                context,
                paternalGrandmother,
                "👵🏻",
                FamilyCodes.GrandmaFather,
              ),
            ],
          ),
          verticalSpacing(16),
          buildMainItem(context, father, "🧔🏻‍♂️",
              AppColorsManager.mainDarkBlue, FamilyCodes.Dad),
          verticalSpacing(16),
          Wrap(
            spacing: 16,
            runAlignment: WrapAlignment.spaceEvenly,
            runSpacing: 8,
            children: brothers.map(
              (brother) {
                return buildRelativeItem(
                  context,
                  brother,
                  "👦🏻",
                  Color.fromARGB(169, 38, 139, 202),
                  FamilyCodes.Bro,
                );
              },
            ).toList(),
          ),
          verticalSpacing(12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              ...paternalUncles.map(
                (uncle) => buildRelativeItem(
                  context,
                  uncle,
                  "👨🏻‍🦱",
                  Color(0xff5A4B8D),
                  FamilyCodes.FatherSideUncle,
                ),
              ),
              ...paternalAunts.map(
                (aunt) => buildRelativeItem(
                  context,
                  aunt,
                  "👩🏻‍🦱",
                  Color(0xff5A4B8D),
                  FamilyCodes.FatherSideAunt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMotherRelativesPart(
      BuildContext context, GetFamilyMembersNames? familyMembersNames) {
    final maternalGrandfather = familyMembersNames!.grandpaMother!.first;
    final maternalGrandmother = familyMembersNames.grandmaMother!.first;
    final mother = familyMembersNames.mother!.first;
    final sisters = familyMembersNames.sis ?? ["أخت"];
    final maternalUncles = familyMembersNames.motherSideUncle ?? ["خال"];
    final maternalAunts = familyMembersNames.motherSideAunt ?? ["خالة"];
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BulletLabel(label: "الإخوة", color: Color(0xff99CBE9)),
          verticalSpacing(8),
          BulletLabel(label: "الأخوال و العمات", color: Color(0xff5A4B8D)),
          verticalSpacing(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStaticItem(
                context,
                maternalGrandfather,
                "👴🏻",
                FamilyCodes.GrandpaMother,
              ),
              buildStaticItem(
                context,
                maternalGrandmother,
                "👵🏻",
                FamilyCodes.GrandmaMother,
              ),
            ],
          ),
          verticalSpacing(16),
          buildMainItem(
            context,
            mother,
            "👩🏻‍🦳",
            AppColorsManager.mainDarkBlue,
            FamilyCodes.Mam,
          ),
          verticalSpacing(16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: sisters.map((sister) {
              return buildRelativeItem(
                context,
                sister,
                "👩🏻",
                Color.fromARGB(169, 38, 139, 202),
                FamilyCodes.Sis,
              );
            }).toList(),
          ),
          verticalSpacing(12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              ...maternalUncles.map(
                (uncle) => buildRelativeItem(
                  context,
                  uncle,
                  "👨🏻‍🦱",
                  Color(0xff5A4B8D),
                  FamilyCodes.MotherSideUncle,
                ),
              ),
              ...maternalAunts.map(
                (aunt) => buildRelativeItem(
                  context,
                  aunt,
                  "👩🏻‍🦱",
                  Color(0xff5A4B8D),
                  FamilyCodes.MotherSideAunt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BulletLabel extends StatelessWidget {
  final String label;
  final Color color;

  const BulletLabel({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
        horizontalSpacing(4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font18blackWight500.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
