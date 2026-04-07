import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/home_tab/Presentation/views/medicines_compatibility/logic/medicines_compatibility_cubit.dart';
import 'package:we_care/features/home_tab/Presentation/views/medicines_compatibility/logic/medicines_compatibility_state.dart';
import 'package:we_care/features/medication_compatibility/data/models/clinical_audit_report_model.dart'
    as model;
import 'package:we_care/features/medication_compatibility/presentation/views/medication_compatibility_ai_consultation_view.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/compatibility_issue_card.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/risk_levels_row_widget.dart';

class MedicinesCombitabilityReesultsView extends StatelessWidget {
  const MedicinesCombitabilityReesultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicinesCompatibilityCubit,
        MedicinesCompatibilityState>(
      builder: (context, state) {
        final auditReport = state.auditReport?.clinicalAuditReport;

        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const AppBarWithCenteredTitle(
                  title: "نتائج تحليل التوافق الدوائي",
                  showActionButtons: false,
                ),
              ),
              verticalSpacing(20),
              if (auditReport == null)
                const Expanded(
                  child: Center(
                    child: Text("لا توجد بيانات متاحة حالياً"),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    children: [
                      const RiskLevelsLegend(),
                      verticalSpacing(10),
                      AppCustomButton(
                        title: "استشر الـ AI",
                        isEnabled: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MedicationCompatibilityConsultationView(
                                initialMessage:
                                    _generateAITemplate(auditReport),
                              ),
                            ),
                          );
                        },
                      ),
                      verticalSpacing(15),
                      _buildSectionHeader("تداخلات المواد الكيميائية (Matrix)"),
                      _buildItemsList(
                        "التضاد (Antagonism)",
                        auditReport.chemicalInteractionMatrix.antagonism
                            .map((e) => _InteractionCard(
                                  title: e.title,
                                  description: e.description,
                                  riskLevel: e.riskLevel,
                                  action: e.action,
                                  extraInfo: e.drugsInvolved,
                                  isChemical: true,
                                ))
                            .toList(),
                      ),
                      _buildItemsList(
                        "التآزر (Synergy)",
                        auditReport.chemicalInteractionMatrix.synergy
                            .map((e) => _InteractionCard(
                                  title: e.title,
                                  description: e.description,
                                  riskLevel: e.riskLevel,
                                  action: e.action,
                                  extraInfo: e.drugsInvolved,
                                  isChemical: true,
                                ))
                            .toList(),
                      ),
                      _buildItemsList(
                        "تأثيرات الأدوية السابقة (Residuals)",
                        auditReport.chemicalInteractionMatrix.pastDrugResiduals
                            .map((e) => _InteractionCard(
                                  title: e.title,
                                  description: e.description,
                                  riskLevel: e.riskLevel,
                                  action: e.action,
                                  extraInfo: e.drugsInvolved,
                                  isChemical: true,
                                ))
                            .toList(),
                      ),
                      verticalSpacing(20),
                      _buildSectionHeader("التوافق مع أجهزة الجسم (Systemic)"),
                      _buildItemsList(
                        "الغذاء والمكملات",
                        auditReport.systemicCompatibility.foodAndSupplements
                            .map((e) => _InteractionCard(
                                  title: e.title,
                                  description: e.description,
                                  riskLevel: e.riskLevel,
                                  action: e.action,
                                  extraInfo: e.relatedItems,
                                  isChemical: false,
                                ))
                            .toList(),
                      ),
                      _buildItemsList(
                        "أمان الأعضاء",
                        auditReport.systemicCompatibility.organSafety
                            .map((e) => _InteractionCard(
                                  title: e.title,
                                  description: e.description,
                                  riskLevel: e.riskLevel,
                                  action: e.action,
                                  extraInfo: e.relatedItems,
                                  isChemical: false,
                                ))
                            .toList(),
                      ),
                      _buildItemsList(
                        "تأثيرات سلوكية",
                        auditReport.systemicCompatibility.behavioralImpact
                            .map((e) => _InteractionCard(
                                  title: e.title,
                                  description: e.description,
                                  riskLevel: e.riskLevel,
                                  action: e.action,
                                  extraInfo: e.relatedItems,
                                  isChemical: false,
                                ))
                            .toList(),
                      ),
                      verticalSpacing(20),
                      _buildSectionHeader("دليل استشارة الطبيب"),
                      _buildRiskGuideTable(
                          auditReport.doctorDiscussion.riskTable),
                      verticalSpacing(30),
                      _buildQuestionsSection(
                          auditReport.doctorDiscussion.questions),
                      verticalSpacing(40),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: AppTextStyles.font18blackWight500.copyWith(
          color: AppColorsManager.mainDarkBlue,
        ),
      ),
    );
  }

  Widget _buildItemsList(String title, List<Widget> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
          child: Text(
            title,
            style: AppTextStyles.font16BlackSemiBold.copyWith(
              color: AppColorsManager.mainDarkBlue.withOpacity(0.7),
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildRiskGuideTable(List<model.RiskLevelItem> table) {
    return Card(
      elevation: 0,
      color: AppColorsManager.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: table
              .map((item) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            color: getRiskColor(item.level),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            item.level,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        horizontalSpacing(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.meaning,
                                  style: AppTextStyles.font14BlackMedium),
                              verticalSpacing(4),
                              Text(
                                "الإجراء المطوب: ${item.action}",
                                style: AppTextStyles.font14blackWeight400
                                    .copyWith(
                                        color: AppColorsManager.textColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildQuestionsSection(List<String> questions) {
    if (questions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            "أسئلة لنقاشها مع طبيبك",
            style: AppTextStyles.font16BlackSemiBold.copyWith(
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
        ),
        Card(
          elevation: 0,
          color: Colors.orange.shade50,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: questions
                  .map((q) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.help_outline,
                                color: Colors.orange, size: 18),
                            horizontalSpacing(12),
                            Expanded(
                              child: Text(
                                q,
                                style: AppTextStyles.font14blackWeight400,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  String _generateAITemplate(model.ClinicalAuditReport auditReport) {
    final buffer = StringBuffer();
    buffer.writeln(
        "أنا قمت بتحليل التفاعلات الدوائية الخاصة بي باستخدام تطبيق طبي.");
    buffer.writeln();
    buffer.writeln("ملخص التفاعلات المرصودة:");

    // Chemical Interaction Matrix
    if (auditReport.chemicalInteractionMatrix.antagonism.isNotEmpty ||
        auditReport.chemicalInteractionMatrix.synergy.isNotEmpty ||
        auditReport.chemicalInteractionMatrix.pastDrugResiduals.isNotEmpty) {
      buffer.writeln("1. تداخلات المواد الكيميائية:");
      for (var item in auditReport.chemicalInteractionMatrix.antagonism) {
        buffer.writeln(
            "- ${item.title} (Antagonism): ${item.description}. الأدوية: ${item.drugsInvolved.join(', ')}");
      }
      for (var item in auditReport.chemicalInteractionMatrix.synergy) {
        buffer.writeln(
            "- ${item.title} (Synergy): ${item.description}. الأدوية: ${item.drugsInvolved.join(', ')}");
      }
      for (var item
          in auditReport.chemicalInteractionMatrix.pastDrugResiduals) {
        buffer.writeln(
            "- ${item.title} (Residuals): ${item.description}. الأدوية: ${item.drugsInvolved.join(', ')}");
      }
      buffer.writeln();
    }

    // Systemic Compatibility
    if (auditReport.systemicCompatibility.foodAndSupplements.isNotEmpty ||
        auditReport.systemicCompatibility.organSafety.isNotEmpty ||
        auditReport.systemicCompatibility.behavioralImpact.isNotEmpty) {
      buffer.writeln("2. التوافق مع أجهزة الجسم:");
      for (var item in auditReport.systemicCompatibility.foodAndSupplements) {
        buffer.writeln(
            "- ${item.title}: ${item.description}. المحاور: ${item.relatedItems.join(', ')}");
      }
      for (var item in auditReport.systemicCompatibility.organSafety) {
        buffer.writeln(
            "- ${item.title}: ${item.description}. المحاور: ${item.relatedItems.join(', ')}");
      }
      for (var item in auditReport.systemicCompatibility.behavioralImpact) {
        buffer.writeln(
            "- ${item.title}: ${item.description}. المحاور: ${item.relatedItems.join(', ')}");
      }
      buffer.writeln();
    }

    // Questions
    if (auditReport.doctorDiscussion.questions.isNotEmpty) {
      buffer.writeln("الأسئلة المقترحة للنقاش مع الطبيب:");
      for (var q in auditReport.doctorDiscussion.questions) {
        buffer.writeln("- $q");
      }
    }

    return buffer.toString();
  }
}

class _InteractionCard extends StatelessWidget {
  final String title;
  final String description;
  final String riskLevel;
  final String action;
  final List<String> extraInfo;
  final bool isChemical;

  const _InteractionCard({
    required this.title,
    required this.description,
    required this.riskLevel,
    required this.action,
    required this.extraInfo,
    required this.isChemical,
  });

  @override
  Widget build(BuildContext context) {
    final color = getRiskColor(riskLevel);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        border: Border(right: BorderSide(color: color, width: 4.w)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          bottomLeft: Radius.circular(8.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.font16BlackSemiBold,
                ),
              ),
              horizontalSpacing(8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  riskLevel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          verticalSpacing(8),
          Text(
            description,
            style: AppTextStyles.font14blackWeight400,
          ),
          if (extraInfo.isNotEmpty) ...[
            verticalSpacing(8),
            Text(
              isChemical
                  ? "الأدوية المعنية: ${extraInfo.join(', ')}"
                  : "المحاور المرتبطة: ${extraInfo.join(', ')}",
              style: AppTextStyles.font12blackWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          verticalSpacing(12),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: color, size: 16.sp),
                horizontalSpacing(8),
                Expanded(
                  child: Text(
                    "الإجراء: $action",
                    style: AppTextStyles.font12blackWeight400.copyWith(
                      color: AppColorsManager.mainDarkBlue,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
