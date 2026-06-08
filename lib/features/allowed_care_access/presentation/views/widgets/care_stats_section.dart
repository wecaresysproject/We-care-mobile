import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CareStatsSection extends StatelessWidget {
  final int totalCount;
  final int fullAccessCount;
  final int viewOnlyCount;

  const CareStatsSection({
    super.key,
    required this.totalCount,
    required this.fullAccessCount,
    required this.viewOnlyCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            count: totalCount,
            label: 'إجمالي',
            countColor: AppColorsManager.mainDarkBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            count: fullAccessCount,
            label: 'تحكم كامل',
            countColor: const Color(0xFF2E7D32), // Green
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            count: viewOnlyCount,
            label: 'عرض فقط',
            countColor: AppColorsManager.mainDarkBlue,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final int count;
  final String label;
  final Color countColor;

  const _StatCard({
    required this.count,
    required this.label,
    required this.countColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: AppTextStyles.font14BlueWeight700.copyWith(
              color: countColor,
              fontSize: 24.sp,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.font14blackWeight400.copyWith(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
