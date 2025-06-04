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

  bool isGenericTitle(String title) {
    const genericTitles = {
      'الاب',
      'الام',
      'الاخ',
      'الاخت',
      'الجد',
      'الجده',
      'العم',
      'العمه',
      'الخال',
      'الخاله',
    };

    return genericTitles.contains(title.trim());
  }

  Widget buildStaticItem(
      BuildContext context, String title, String emoji, String code) {
    return GestureDetector(
      onDoubleTap: isGenericTitle(title)
          ? null
          : () async {
              await navigateToNextScreen(context, code, title).then((value) =>
                  context
                      .read<GeneticsDiseasesViewCubit>()
                      .getFamilyMembersNames());
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
        decoration: BoxDecoration(
          color: isGenericTitle(title)
              ? Color(0xff547792).withOpacity(0.8)
              : Color(0xff547792),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
            ),
            verticalSpacing(
              4,
            ),
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

  Widget buildMainItem(BuildContext context, String title, String emoji,
      Color color, String code) {
    return GestureDetector(
      onDoubleTap: isGenericTitle(title)
          ? null
          : () async {
              await navigateToNextScreen(context, code, title);
            },
      child: Container(
        width: double.infinity,
        height: 56.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isGenericTitle(title) ? color.withOpacity(0.8) : color,
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
      BuildContext context, String code, String name) async {
    await context.pushNamed(Routes.familyMemberGeneticDiseases,
        arguments: {'familyMemberCode': code, 'familyMemberName': name});
  }

  Widget buildRelativeItem(BuildContext context, String title, String emoji,
      Color color, String code) {
    return GestureDetector(
      onTap: isGenericTitle(title)
          ? null
          : () async {
              await navigateToNextScreen(context, code, title);
            },
      child: Container(
        width: 73.5.w,
        height: 47.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isGenericTitle(title) ? color.withOpacity(0.8) : color,
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
                    onTap: () {
                      Navigator.pushNamed(
                          context, Routes.numberOfFamilyMembersView);
                    },
                    title: 'تعديل',
                    icon: 'assets/images/edit.png',
                  ),
                ),
              ),
              verticalSpacing(20),
              BlocBuilder<GeneticsDiseasesViewCubit, GeneticsDiseasesViewState>(
                builder: (context, state) {
                  if (state.requestStatus == RequestStatus.loading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state.familyMembersNames == null) {
                    return Column(
                      children: [
                        verticalSpacing(100),
                        Icon(Icons.family_restroom,
                            size: 100.sp, color: Colors.grey),
                        verticalSpacing(16),
                        Text(
                          state.requestStatus == RequestStatus.failure
                              ? state.message!
                              : 'لا توجد بيانات لعائلة مضافة بعد',
                          style: AppTextStyles.font20blackWeight600.copyWith(
                            color: Colors.grey,
                            fontSize: 18.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }

                  // When family tree is not empty
                  return Column(
                    children: [
                      Text(
                        "“عند الضغط على أحد الأقارب تظهر جميع التفاصيل ”",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.font20blackWeight600.copyWith(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      verticalSpacing(19),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildFatherRelativesPart(
                              context, state.familyMembersNames),
                          horizontalSpacing(16),
                          buildMotherRelativesPart(
                              context, state.familyMembersNames),
                        ],
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

  Expanded buildFatherRelativesPart(
      BuildContext context, GetFamilyMembersNames? familyMembersNames) {
    final paternalGrandfather = familyMembersNames!.grandpaFather!.first;
    final paternalGrandmother = familyMembersNames.grandmaFather!.first;
    final father = familyMembersNames.father!.first;
    final brothers = familyMembersNames.bro ?? ["أخ"];
    final paternalUncles = familyMembersNames.fatherSideUncle ?? ["عم"];
    final paternalAunts = familyMembersNames.fatherSideAunt ?? ["عمة"];

    return Expanded(
      child: Column(
        children: [
          BulletLabel(label: "الأجداد", color: Color(0xFF547792)),
          verticalSpacing(8),
          BulletLabel(label: "الآباء", color: Color(0xFF004B84)),
          verticalSpacing(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStaticItem(
                  context, paternalGrandfather, "👴🏻", 'GrandpaFather'),
              horizontalSpacing(16),
              buildStaticItem(
                  context, paternalGrandmother, "👵🏻", 'GrandmaFather'),
            ],
          ),
          verticalSpacing(16),
          buildMainItem(
              context, father, "🧔🏻‍♂️", AppColorsManager.mainDarkBlue, 'Dad'),
          verticalSpacing(16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: brothers.map((brother) {
              return buildRelativeItem(context, brother, "👦🏻",
                  const Color.fromARGB(255, 86, 159, 205), 'Bro');
            }).toList(),
          ),
          verticalSpacing(12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              ...paternalUncles.map((uncle) => buildRelativeItem(context, uncle,
                  "👨🏻‍🦱", Color(0xff5A4B8D), 'FatherSideUncle')),
              ...paternalAunts.map((aunt) => buildRelativeItem(context, aunt,
                  "👩🏻‍🦱", Color(0xff5A4B8D), 'FatherSideAunt')),
            ],
          ),
        ],
      ),
    );
  }

  Expanded buildMotherRelativesPart(
      BuildContext context, GetFamilyMembersNames? familyMembersNames) {
    final maternalGrandfather = familyMembersNames!.grandpaMother!.first;
    final maternalGrandmother = familyMembersNames.grandmaMother!.first;
    final mother = familyMembersNames.mother!.first;
    final sisters = familyMembersNames.sis ?? ["أخت"];
    final maternalUncles = familyMembersNames.motherSideUncle ?? ["خال"];
    final maternalAunts = familyMembersNames.motherSideAunt ?? ["خالة"];

    return Expanded(
      child: Column(
        children: [
          BulletLabel(label: "الإخوة", color: Color(0xff99CBE9)),
          verticalSpacing(8),
          BulletLabel(label: "الأخوال و العمات", color: Color(0xff5A4B8D)),
          verticalSpacing(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStaticItem(
                  context, maternalGrandfather, "👴🏻", "GrandpaMother"),
              horizontalSpacing(16),
              buildStaticItem(
                  context, maternalGrandmother, "👵🏻", 'GrandmaMother'),
            ],
          ),
          verticalSpacing(16),
          buildMainItem(
              context, mother, "👩🏻‍🦳", AppColorsManager.mainDarkBlue, 'Mom'),
          verticalSpacing(16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: sisters.map((sister) {
              return buildRelativeItem(context, sister, "👩🏻",
                  const Color.fromARGB(255, 86, 159, 205), "Sis");
            }).toList(),
          ),
          verticalSpacing(12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              ...maternalUncles.map((uncle) => buildRelativeItem(context, uncle,
                  "👨🏻‍🦱", Color(0xff5A4B8D), "MotherSideUncle")),
              ...maternalAunts.map((aunt) => buildRelativeItem(context, aunt,
                  "👩🏻‍🦱", Color(0xff5A4B8D), "MotherSideAunt")),
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
