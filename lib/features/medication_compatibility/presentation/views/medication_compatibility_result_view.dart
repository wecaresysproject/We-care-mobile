import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/medication_compatibility_ai_consultation_view.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/compatibility_issue_card.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/compatibility_summary_card.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/risk_levels_row_widget.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/simulated_medical_modules_checklist_loader.dart';
import 'package:we_care/features/medicine/data/models/medical_compatibility_analysis_model.dart';
import 'package:we_care/features/medicine/logic/medication_compatibility_analysis_pdf_generator.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicationCompatibilityResultView extends StatelessWidget {
  const MedicationCompatibilityResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicinesDataEntryCubit, MedicinesDataEntryState>(
      builder: (context, state) {
        final analysis = state.compatibilityAnalysis;

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: Column(
            children: [
              AppBarWithCenteredTitle(
                title: "نتيجة التوافق",
                showActionButtons: true,
                showShareButtonOnly: true,
                shareFunction: () async {
                  if (analysis != null) {
                    await _sharePdf(context, analysis);
                  }
                },
              ).paddingSymmetricHorizontal(20),
              const SizedBox(height: 20),
              const RiskLevelsLegend(),
              Expanded(
                child: () {
                  if (state.analyzeMedicalCompatibilityStatus ==
                      RequestStatus.loading) {
                    return const SimulatedMedicalModulesChecklistLoader();
                  }

                  if (state.analyzeMedicalCompatibilityStatus ==
                      RequestStatus.failure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          state.message.isNotEmpty
                              ? state.message
                              : "حدث خطأ أثناء تحليل التوافق",
                          style: AppTextStyles.font16BlackSemiBold.copyWith(
                            color: AppColorsManager.warningColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (state.analyzeMedicalCompatibilityStatus ==
                          RequestStatus.success &&
                      analysis != null) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CompatibilitySummaryCard(analysis: analysis),
                          const SizedBox(height: 16),
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
                                        _generateAITemplate(analysis),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          if (analysis.issues.isEmpty)
                            _buildNoIssuesState()
                          else ...[
                            Text(
                              "التداخلات المرصودة",
                              style: AppTextStyles.font18blackWight500.copyWith(
                                color: AppColorsManager.mainDarkBlue,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: analysis.issues.length,
                              itemBuilder: (context, index) {
                                return CompatibilityIssueCard(
                                  issue: analysis.issues[index],
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return const Center(
                    child: Text("لا توجد بيانات متاحة حالياً"),
                  );
                }(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sharePdf(
      BuildContext context, CompatibilityAnalysisModel analysis) async {
    try {
      final pdfBytes = await MedicationCompatibilityAnalysisPdfGenerator()
          .generateCompatibilityReport(analysis);

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/medication_compatibility_report.pdf');
      await file.writeAsBytes(pdfBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'تقرير التوافق الدوائي',
        subject: 'Compatibility Report',
      );
    } catch (e) {
      AppLogger.info(" error is $e");
      if (context.mounted) {
        showError("حدث خطأ أثناء إنشاء أو مشاركة التقرير");
      }
    }
  }

  String _generateAITemplate(CompatibilityAnalysisModel analysis) {
    final buffer = StringBuffer();
    buffer.writeln(
        "أنا قمت بتحليل التفاعلات الدوائية الخاصة بي باستخدام تطبيق طبي.");
    buffer.writeln();
    buffer.writeln("ملخص التحليل:");
    buffer.writeln(analysis.analysisSummary);
    buffer.writeln();

    if (analysis.issues.isNotEmpty) {
      buffer.writeln("التفاعلات المكتشفة:");
      buffer.writeln();
      for (int i = 0; i < analysis.issues.length; i++) {
        final issue = analysis.issues[i];
        buffer.writeln("${i + 1}. ${issue.title}");
        buffer.writeln("مستوى الخطورة: ${issue.riskLevel}");
        buffer.writeln("السبب العلمي: ${issue.scientificReason}");
        buffer.writeln("سؤال للطبيب: ${issue.doctorQuestion}");
        buffer.writeln();
      }
    } else {
      buffer.writeln("لا يوجد تعارض دوائي خطير بناءً على البيانات المتاحة.");
    }

    return buffer.toString();
  }

  Widget _buildNoIssuesState() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              "لا يوجد تعارض دوائي خطير بناءً على البيانات المتاحة.",
              textAlign: TextAlign.center,
              style: AppTextStyles.font16BlackSemiBold.copyWith(
                color: Colors.green.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
