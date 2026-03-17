import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/data/models/medical_compatibility_analysis_model.dart';

class CompatibilityIssueCard extends StatelessWidget {
  final CompatibilityIssue issue;

  const CompatibilityIssueCard({super.key, required this.issue});

  String getRiskLabel(String level) {
    switch (level.toUpperCase()) {
      case 'L1':
        return 'حرج';
      case 'L2':
        return 'مرتفع';
      case 'L3':
        return 'متوسط';
      case 'L4':
        return 'منخفض';
      case 'L5':
        return 'احترازي';
      default:
        return 'تنبيه';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color riskColor = getRiskColor(issue.riskLevel);
    final String riskLabel = getRiskLabel(issue.riskLevel);

    return Card(
      color: const Color.fromARGB(255, 231, 239, 243),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    issue.title,
                    style: AppTextStyles.font16BlackSemiBold.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: riskColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    riskLabel,
                    style: AppTextStyles.font12blackWeight400.copyWith(
                      color: riskColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: "السبب العلمي",
              content: issue.scientificReason,
              icon: Icons.science_outlined,
              iconColor: AppColorsManager.mainDarkBlue,
            ),
            const SizedBox(height: 12),
            _buildSection(
              title: "سؤال للطبيب",
              content: issue.doctorQuestion,
              icon: Icons.question_answer_outlined,
              iconColor: AppColorsManager.doneColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.font14BlackMedium.copyWith(
                color: iconColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(right: 26),
          child: Text(
            content,
            style: AppTextStyles.font14blackWeight400,
          ),
        ),
      ],
    );
  }
}

Color getRiskColor(String riskLevel) {
  switch (riskLevel.toUpperCase()) {
    case 'L1':
      return AppColorsManager.criticalRisk;
    case 'L2':
      return AppColorsManager.elevatedRisk;
    case 'L3':
      return AppColorsManager.warning;
    case 'L4':
      return Colors.blue;
    case 'L5':
      return Colors.grey;
    default:
      return Colors.black;
  }
}
