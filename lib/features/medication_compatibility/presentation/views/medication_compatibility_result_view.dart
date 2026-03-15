import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/compatibility_issue_card.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/compatibility_summary_card.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicationCompatibilityResultView extends StatelessWidget {
  const MedicationCompatibilityResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          AppBarWithCenteredTitle(
            title: "نتيجة التحليل",
            showActionButtons: false,
          ).paddingSymmetricHorizontal(20),
          const SizedBox(height: 20),
          Expanded(
            child:
                BlocBuilder<MedicinesDataEntryCubit, MedicinesDataEntryState>(
              builder: (context, state) {
                if (state.analyzeMedicalCompatibilityStatus ==
                    RequestStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColorsManager.mainDarkBlue,
                    ),
                  );
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
                    state.compatibilityAnalysis != null) {
                  final analysis = state.compatibilityAnalysis!;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CompatibilitySummaryCard(),
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
              },
            ),
          ),
        ],
      ),
    );
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
