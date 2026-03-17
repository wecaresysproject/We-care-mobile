import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/compatibility_issue_card.dart';

class RiskLevelItem extends StatelessWidget {
  final String level;
  final String label;

  const RiskLevelItem({
    super.key,
    required this.level,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = getRiskColor(level);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              level,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class RiskLevelsLegend extends StatelessWidget {
  const RiskLevelsLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RiskLevelItem(level: "L1", label: "حرج"),
        RiskLevelItem(level: "L2", label: "مرتفع"),
        RiskLevelItem(level: "L3", label: "متوسط"),
        RiskLevelItem(level: "L4", label: "منخفض"),
        RiskLevelItem(level: "L5", label: "احترازي"),
      ],
    ).paddingSymmetricHorizontal(20);
  }
}
