import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CompatibilitySummaryCard extends StatelessWidget {
  const CompatibilitySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColorsManager.secondaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined,
                    color: AppColorsManager.mainDarkBlue),
                const SizedBox(width: 8),
                Text(
                  "ملخص التحليل",
                  style: AppTextStyles.font18blackWight500.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
              ],
            ),
            const Divider(color: AppColorsManager.mainDarkBlue, thickness: 0.5),
            const SizedBox(height: 8),
            Text(
              "تم تحليل التوافق بين الدواء الجديد والملف الطبي للمريض. تم اكتشاف بعض التداخلات الدوائية التي تتطلب الانتباه والمتابعة مع الطبيب.",
              style: AppTextStyles.font14blackWeight400.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
