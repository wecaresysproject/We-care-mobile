import 'dart:developer';

import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_umbrella_model.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_cubit.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_state.dart';

class MentalIllnessesUmbrellRecordsView extends StatefulWidget {
  const MentalIllnessesUmbrellRecordsView({super.key});

  @override
  State<MentalIllnessesUmbrellRecordsView> createState() =>
      _MentalIllnessesUmbrellRecordsViewState();
}

class _MentalIllnessesUmbrellRecordsViewState
    extends State<MentalIllnessesUmbrellRecordsView> {
  // Control open/close logic
  int? openedIndex;

  final List<MentalIllnessUmbrellaModel> dummyMentalIllnessCategories = [
    MentalIllnessUmbrellaModel(
      id: 'risk_001',
      title: 'الأفكار الوسواسية والمعتقدات المنحرفة',
      riskLevel: RiskLevel.confirmedRisk,
      followUpMonths: 6,
      answeredQuestionsCount: 12,
      lastMonthScore: 18,
      cumulativeScore: 85,
    ),
    MentalIllnessUmbrellaModel(
      id: 'risk_009',
      title: 'الأفكار الوسواسية والمعتقدات المنحرفة',
      riskLevel: RiskLevel.confirmedRisk,
      followUpMonths: 6,
      answeredQuestionsCount: 12,
      lastMonthScore: 18,
      cumulativeScore: 85,
    ),
    MentalIllnessUmbrellaModel(
      id: 'risk_002',
      title: 'الأفكار الوسواسية والمعتقدات المنحرفة',
      riskLevel: RiskLevel.confirmedRisk,
      followUpMonths: 6,
      answeredQuestionsCount: 12,
      lastMonthScore: 18,
      cumulativeScore: 85,
    ),
    MentalIllnessUmbrellaModel(
      id: 'risk_003',
      title: 'الحالة المزاجية',
      riskLevel: RiskLevel.partialRisk,
      followUpMonths: 4,
      answeredQuestionsCount: 10,
      lastMonthScore: 14,
      cumulativeScore: 55,
    ),
    MentalIllnessUmbrellaModel(
      id: 'risk_004',
      title: 'العلاقات الاجتماعية والاندماج المجتمعي',
      riskLevel: RiskLevel.underObservation,
      followUpMonths: 5,
      answeredQuestionsCount: 9,
      lastMonthScore: 13,
      cumulativeScore: 60,
    ),
    MentalIllnessUmbrellaModel(
      id: 'risk_005',
      title: 'الذاكرة والانتباه والاضطرابات الحسية',
      riskLevel: RiskLevel.normal,
      followUpMonths: 2,
      answeredQuestionsCount: 7,
      lastMonthScore: 10,
      cumulativeScore: 35,
    ),
    MentalIllnessUmbrellaModel(
      id: 'risk_006',
      title: 'القلق والتوتر والاضطرابات النفسية',
      riskLevel: RiskLevel.confirmedRisk,
      followUpMonths: 8,
      answeredQuestionsCount: 15,
      lastMonthScore: 20,
      cumulativeScore: 90,
    ),
    MentalIllnessUmbrellaModel(
      id: 'risk_007',
      title: 'الاضطرابات السلوكية والانفعالية',
      riskLevel: RiskLevel.partialRisk,
      followUpMonths: 4,
      answeredQuestionsCount: 11,
      lastMonthScore: 16,
      cumulativeScore: 70,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MentalIllnessDataViewCubit>(
      create: (context) => getIt<
          MentalIllnessDataViewCubit>()..getMedicalIllnessUmbrellaDocs(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CustomAppBarWidget(
                    haveBackArrow: true,
                  ),
                  verticalSpacing(40),
                  _buildActionButtons(),
                  verticalSpacing(36),
                  const SizedBox(height: 24),
                  _buildSeverityIndicator(),
                  const SizedBox(height: 24),
                  BlocBuilder<MentalIllnessDataViewCubit,
                      MentalIllnessDataViewState>(
                    builder: (context, state) {
                      // Handle different states
                      if (state.requestStatus == RequestStatus.loading) {
                        //  !state.isLoadingMore) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.requestStatus == RequestStatus.failure) {
                        return Center(
                          child: Text(
                            state.responseMessage.isNotEmpty
                                ? state.responseMessage
                                : 'حدث خطأ ما',
                            style: AppTextStyles.font22MainBlueWeight700,
                          ),
                        );
                      }

                      final records = state.mentalIllnessUmbrellaRecords;
                      if (records.isEmpty) {
                        return Center(
                          child: Text(
                            'لا توجد بيانات',
                            style: AppTextStyles.font22MainBlueWeight700,
                          ),
                        );
                      }
              
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: records.length,
                        reverse: true, // This ensures proper z-index layering
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                        ),
                        itemBuilder: (context, index) {
                          final category = records[index];
                          final isOpen = openedIndex == index;

                          return OverflowBox(
                            maxHeight:
                                400, // Adjust this value based on your content height
                            alignment: Alignment.topCenter,
                            child: Accordion(
                              disableScrolling: false,
                              paddingListTop: 0,
                              paddingBetweenOpenSections: 0,
                              paddingBetweenClosedSections: 0,
                              paddingListBottom: 0,
                              maxOpenSections: 1,
                              headerBackgroundColor:
                                  getCategoryColorRelativeToRiskLevel(
                                      category.riskLevel),
                              paddingListHorizontal: 10,
                              flipLeftIconIfOpen: true,
                              contentVerticalPadding: 4,
                              contentBorderColor:
                                  getCategoryColorRelativeToRiskLevel(
                                category.riskLevel,
                              ),
                              contentBackgroundColor:
                                  Colors.white, // Make content background solid
                              contentBorderRadius: 12.r,
                              contentHorizontalPadding: 12,
                              contentBorderWidth: 2,
                              openAndCloseAnimation: true,
                              headerBorderColor: Colors.transparent,
                              headerBorderRadius: 16.r,
                              headerPadding:
                                  EdgeInsets.symmetric(horizontal: 12.w),
                              flipRightIconIfOpen: false,
                              scaleWhenAnimating: true,
                              rightIcon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 26,
                                color: _getCategoryTitleDesiredColor(category),
                              ),
                              children: [
                                AccordionSection(
                                  isOpen: isOpen,
                                  index: openedIndex ?? 0,
                                  onOpenSection: () {
                                    setState(() => openedIndex = index);
                                  },
                                  onCloseSection: () {
                                    setState(() => openedIndex = null);
                                  },
                                  contentBorderColor:
                                      getCategoryColorRelativeToRiskLevel(
                                    category.riskLevel,
                                  ).withOpacity(0.3),
                                  header: Container(
                                    height: 70.h,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          getCategoryColorRelativeToRiskLevel(
                                        category.riskLevel,
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            category.title,
                                            style: AppTextStyles
                                                .font14whiteWeight600
                                                .copyWith(
                                              fontSize: 13.2.sp,
                                              color:
                                                  _getCategoryTitleDesiredColor(
                                                      category),
                                              fontWeight: category.riskLevel ==
                                                      RiskLevel.confirmedRisk
                                                  ? FontWeight.bold
                                                  : FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  content: _buildExpandedContent(category),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            // Optional: Add a semi-transparent overlay when any item is expanded
            if (openedIndex != null)
              GestureDetector(
                onTap: () {
                  setState(() => openedIndex = null);
                },
                child: SizedBox.shrink(),
              ),
          ],
        ),
      ),
    );
  }

  /// Returns color corresponding to the given [RiskLevel].
  Color getCategoryColorRelativeToRiskLevel(RiskLevel level) {
    switch (level) {
      case RiskLevel.normal:
        return AppColorsManager.safe;
      case RiskLevel.underObservation:
        return AppColorsManager.warning;
      case RiskLevel.partialRisk:
        return AppColorsManager.elevatedRisk;
      case RiskLevel.confirmedRisk:
        return AppColorsManager.criticalRisk;
    }
  }

  Widget _buildSeverityIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSeverityItem('طبيعي', AppColorsManager.safe),
        _buildSeverityItem('مراقبة', AppColorsManager.warning),
        _buildSeverityItem('خطر جزئي', AppColorsManager.elevatedRisk),
        _buildSeverityItem('خطر مؤكد', AppColorsManager.criticalRisk),
      ],
    );
  }

  _getCategoryTitleDesiredColor(MentalIllnessUmbrellaModel category) {
    if (category.riskLevel == RiskLevel.confirmedRisk) {
      return Colors.white;
    }
    return Colors.black;
  }

  Widget _buildSeverityItem(String label, Color color) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: color, radius: 12),
        horizontalSpacing(4),
        Text(
          label,
          style: AppTextStyles.font14whiteWeight600.copyWith(
            color: AppColorsManager.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent(MentalIllnessUmbrellaModel category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category.riskLevel == RiskLevel.confirmedRisk)
          Column(
            children: [
              _buildContactItem(
                  'تواصل مع مختص', 'assets/images/support_team_member.png'),
              const Divider(height: 1),
            ],
          ),
        if (category.riskLevel == RiskLevel.partialRisk) ...[
          Column(
            children: [
              _buildContactItem(
                  'تواصل مع مختص', 'assets/images/support_team_member.png'),
              const Divider(height: 1),
              _buildContactItem(
                  'غرف الدعم', 'assets/images/support_rooms_icon.png'),
              const Divider(height: 1),
            ],
          ),
        ],
        _buildStatRow('عدد أشهر المتابعة:', category.followUpMonths.toString()),
        const Divider(height: 1),
        _buildStatRow(
            'عدد الأسئلة المجابة:', category.answeredQuestionsCount.toString()),
        const Divider(height: 1),
        _buildStatRow('درجات أشهر الخطر:', category.lastMonthScore.toString()),
        const Divider(height: 1),
        _buildStatRow(
            'الدرجات التراكمية:', category.cumulativeScore.toString()),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildContactItem(String title, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 14.sp,
            ),
          ),
          const Spacer(),
          Image.asset(iconPath, height: 26, width: 26),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            title: 'الأسئلة المجاب عليها يعم',
            iconPath: "assets/images/question_mark.png",
            onTap: () async {
              log('nnaaavigatttte');
              await context.pushNamed(
                Routes.mentalIllnessAnsweredQuestionsView,
              );
            },
          ),
        ),
        horizontalSpacing(16),
        Expanded(
          child: _buildActionButton(
            title: 'تقارير المتابعة',
            iconPath: 'assets/images/medical_reports_image.png',
            onTap: () async {
              await context.pushNamed(Routes.mentalIllnessFollowUpReports);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required String iconPath,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColorsManager.mainDarkBlue,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              color: AppColorsManager.mainDarkBlue,
              width: 24,
              height: 24,
            ),
            horizontalSpacing(5.5),
            Flexible(
              child: Text(
                title,
                style: AppTextStyles.font14whiteWeight600.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
