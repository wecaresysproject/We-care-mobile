import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_profile.dart';

class PermissionBadge extends StatelessWidget {
  final PermissionType permissionType;

  const PermissionBadge({super.key, required this.permissionType});

  @override
  Widget build(BuildContext context) {
    final bool isFullAccess = permissionType == PermissionType.fullAccess;
    final String label = isFullAccess ? 'تحكم كامل' : 'عرض فقط';

    // We Care typical colors: use medical green for full access, blue/grey for view only.
    // Or based on design: soft green background for full access, soft blue for view only.
    final Color bgColor = isFullAccess
        ? const Color(0xFFE8F5E9) // soft green
        : const Color(0xFFE3F2FD); // soft blue
    final Color textColor = isFullAccess
        ? const Color(0xFF2E7D32) // dark green
        : const Color(0xFF1565C0); // dark blue

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.font14BlueWeight700.copyWith(
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
