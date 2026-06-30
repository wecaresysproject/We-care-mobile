import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class AddedAtBadge extends StatelessWidget {
  final String label;

  const AddedAtBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8), // Soft grey background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_filled,
            size: 14,
            color: Colors.grey.shade600,
          ),
          horizontalSpacing(4),
          Text(
            'مضاف في ${label.toArabicFormattedDate()}',
            style: AppTextStyles.font14blackWeight400.copyWith(
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
