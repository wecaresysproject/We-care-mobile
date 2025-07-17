import 'dart:developer';

import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/data/models/severity_level_enum.dart';
import 'package:we_care/features/medical_illnesses/data/models/umbrella_mental_ilness_record_model.dart';

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

  final List<UmbrellaMentalIlnesssRecordModel> categories = [
    UmbrellaMentalIlnesssRecordModel(
        'الأفكار الوسواسية\nوالمعتقدات\nالمنحرفة',
        SeverityLevel.confirmedRisk,
        AppColorsManager.criticalRisk,
        Icons.psychology,
        45,
        45,
        45,
        45),
    UmbrellaMentalIlnesssRecordModel(
      'الأفكار السلبية\nوالاتجاهات\nالتدميرية',
      SeverityLevel.normal,
      AppColorsManager.safe,
      Icons.dangerous,
      45,
      45,
      45,
      45,
    ),
    UmbrellaMentalIlnesssRecordModel(
      'الحالة المزاجية',
      SeverityLevel.partialRisk,
      AppColorsManager.elevatedRisk,
      Icons.mood,
      45,
      45,
      45,
      45,
    ),
    UmbrellaMentalIlnesssRecordModel(
        'العلاقات الاجتماعية\nوالاندماج المجتمعي',
        SeverityLevel.monitoring,
        AppColorsManager.warning,
        Icons.people,
        45,
        45,
        45,
        45),
    UmbrellaMentalIlnesssRecordModel(
      'الذكيرة والانتباه\nوالاضطرابات\nالتذكيرية والحسية',
      SeverityLevel.normal,
      Colors.green,
      Icons.memory,
      45,
      45,
      45,
      45,
    ),
    UmbrellaMentalIlnesssRecordModel(
        'الأفكار الوسواسية\nوالمعتقدات\nالمنحرفة',
        SeverityLevel.confirmedRisk,
        AppColorsManager.criticalRisk,
        Icons.psychology,
        45,
        45,
        45,
        45),
    UmbrellaMentalIlnesssRecordModel(
      'الأفكار السلبية\nوالاتجاهات\nالتدميرية',
      SeverityLevel.normal,
      AppColorsManager.safe,
      Icons.dangerous,
      45,
      45,
      45,
      45,
    ),
    UmbrellaMentalIlnesssRecordModel(
      'الحالة المزاجية',
      SeverityLevel.partialRisk,
      AppColorsManager.elevatedRisk,
      Icons.mood,
      45,
      45,
      45,
      45,
    ),
    UmbrellaMentalIlnesssRecordModel(
        'العلاقات الاجتماعية\nوالاندماج المجتمعي',
        SeverityLevel.monitoring,
        AppColorsManager.warning,
        Icons.people,
        45,
        45,
        45,
        45),
    UmbrellaMentalIlnesssRecordModel(
      'الذكيرة والانتباه\nوالاضطرابات\nالتذكيرية والحسية',
      SeverityLevel.normal,
      Colors.green,
      Icons.memory,
      45,
      45,
      45,
      45,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  reverse: true, // This ensures proper z-index layering
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
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
                        headerBackgroundColor: category.color,
                        paddingListHorizontal: 10,
                        flipLeftIconIfOpen: true,
                        contentVerticalPadding: 4,
                        contentBorderColor: category.color,
                        contentBackgroundColor:
                            Colors.white, // Make content background solid
                        contentBorderRadius: 12.r,
                        contentHorizontalPadding: 12,
                        contentBorderWidth: 2,
                        openAndCloseAnimation: true,
                        headerBorderColor: Colors.transparent,
                        headerBorderRadius: 16.r,
                        headerPadding: EdgeInsets.symmetric(horizontal: 12.w),
                        flipRightIconIfOpen: false,
                        scaleWhenAnimating: true,
                        rightIcon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 26,
                          color: _getDesiredColor(category),
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
                            contentBorderColor: category.color.withOpacity(0.3),
                            header: Container(
                              height: 70.h,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: category.color,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      category.title,
                                      style: AppTextStyles.font14whiteWeight600
                                          .copyWith(
                                        fontSize: 13.2.sp,
                                        color: _getDesiredColor(category),
                                        fontWeight: category.severityLevel ==
                                                SeverityLevel.confirmedRisk
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
    );
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

  _getDesiredColor(UmbrellaMentalIlnesssRecordModel category) {
    if (category.severityLevel == SeverityLevel.confirmedRisk) {
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

  Widget _buildExpandedContent(UmbrellaMentalIlnesssRecordModel category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category.severityLevel == SeverityLevel.confirmedRisk)
          Column(
            children: [
              _buildContactItem(
                  'تواصل مع مختص', 'assets/images/support_team_member.png'),
              const Divider(height: 1),
            ],
          ),
        if (category.severityLevel == SeverityLevel.partialRisk) ...[
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
        _buildStatRow('عدد أشهر المتابعة:', category.followUpCount.toString()),
        const Divider(height: 1),
        _buildStatRow(
            'عدد الأسئلة المجابة:', category.answeredQuestions.toString()),
        const Divider(height: 1),
        _buildStatRow('درجات أشهر الخطر:', category.riskScores.toString()),
        const Divider(height: 1),
        _buildStatRow(
            'الدرجات التراكمية:', category.cumulativeScores.toString()),
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
          horizontalSpacing(4),
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
            title: 'الأسئلة المجاني عليها يعم',
            iconPath: "assets/images/question_mark.png",
            onTap: () {},
          ),
        ),
        horizontalSpacing(16),
        Expanded(
          child: _buildActionButton(
            title: 'تقارير المتابعة',
            iconPath: 'assets/images/medical_reports_image.png',
            onTap: () async {
              log('jjjjj');
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
