import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/quick_action_tile_widget.dart';
import 'package:we_care/generated/l10n.dart';

class QuickActionsGridWidget extends StatelessWidget {
  const QuickActionsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Temporarily removed from the grid — kept here for quick restoration:
          // QuickActionTileWidget(
          //   iconAssetPath: 'assets/svgs/doctor_icon_edit.svg',
          //   label: S.of(context).editExaminationValueAction,
          //   iconWidth: 24,
          //   iconHeight: 20,
          // ),
          QuickActionTileWidget(
            iconAssetPath: 'assets/svgs/doctor_icon_email.svg',
            label: S.of(context).messageToDoctorAction,
            iconWidth: 24,
            iconHeight: 22,
            verticalPadding: 14,
          ),
          SizedBox(width: 16.w),
          QuickActionTileWidget(
            iconAssetPath: 'assets/svgs/doctor_icon_files.svg',
            label: S.of(context).patientFilesAction,
            iconWidth: 22,
            iconHeight: 20,
            verticalPadding: 14,
          ),
          SizedBox(width: 16.w),

          QuickActionTileWidget(
            iconAssetPath: 'assets/svgs/doctor_icon_correct.svg',
            label: S.of(context).activateOnlineSessionAction,
            iconWidth: 22,
            iconHeight: 20,
            onTap: () =>
                Navigator.pushNamed(context, Routes.doctorBookingsView),
          ),
          // QuickActionTileWidget(
          //   iconAssetPath: 'assets/svgs/doctor_icon_file2.svg',
          //   label: S.of(context).basicDataAction,
          //   iconWidth: 22,
          //   iconHeight: 20,
          //   onTap: () => Navigator.pushNamed(context, Routes.doctorBasicDataView),
          // ),
          // QuickActionTileWidget(
          //   iconAssetPath: 'assets/svgs/doctor_icon_stats_file.svg',
          //   label: S.of(context).onlineExamStatsAction,
          //   iconWidth: 22,
          //   iconHeight: 20,
          // ),
        ],
      ),
    );
  }
}
