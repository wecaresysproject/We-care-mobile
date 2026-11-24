import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/quick_action_tile_widget.dart';

/// The home quick-actions grid: two rows of three cards, laid out in
/// physical left-to-right order (the doctor home is forced LTR).
class QuickActionsGridWidget extends StatelessWidget {
  const QuickActionsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuickActionsRow(
          children: [
            const QuickActionTileWidget(
              iconAssetPath:
                  'assets/images/doctor_action_scheduled_bookings.png',
              label: 'الحجوزات\nالمجدولة',
            ),
            QuickActionTileWidget(
              iconAssetPath: 'assets/images/doctor_action_patient_files.png',
              label: 'ملفات المرضى',
              onTap: () =>
                  Navigator.pushNamed(context, Routes.doctorPatientFilesView),
            ),
            QuickActionTileWidget(
              iconAssetPath: 'assets/images/doctor_action_online_session.png',
              label: 'تفعيل جلسة\nأونلاين',
              showLiveDot: true,
              onTap: () =>
                  Navigator.pushNamed(context, Routes.doctorBookingsView),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _QuickActionsRow(
          children: [
            const QuickActionTileWidget(
              iconAssetPath: 'assets/images/doctor_action_patient_messages.png',
              label: 'رسائل المرضى',
            ),
            const QuickActionTileWidget(
              iconAssetPath:
                  'assets/images/doctor_action_account_statements.png',
              label: 'كشوف الحساب',
            ),
            QuickActionTileWidget(
              iconAssetPath: 'assets/images/doctor_action_statistics.png',
              label: 'إحصائيات',
              onTap: () =>
                  Navigator.pushNamed(context, Routes.doctorStatisticsView),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i != 0) SizedBox(width: 12.w),
            children[i],
          ],
        ],
      ),
    );
  }
}
