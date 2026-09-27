import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_action_tile_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// Bottom-sheet quick-action grid on the video call screen: 4 tiles on the
/// first row, 2 wider tiles on the second — matching the reference design.
class VideoCallActionsGridWidget extends StatelessWidget {
  const VideoCallActionsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VideoCallActionTileWidget(
                  iconAssetPath:
                      'assets/svgs/doctor_icon_new_medicine_approval.svg',
                  label: S.of(context).newMedicineApprovalAction,
                  backgroundColor:
                      AppColorsManager.videoCallNewMedicineTileBackground,
                  iconColor: AppColorsManager.homePrimaryBlue,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: VideoCallActionTileWidget(
                  iconAssetPath:
                      'assets/svgs/doctor_icon_my_medicines_approval.svg',
                  label: S.of(context).myMedicinesApprovalAction,
                  backgroundColor:
                      AppColorsManager.videoCallMyMedicinesTileBackground,
                  iconColor: AppColorsManager.homeTargetOrange,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: VideoCallActionTileWidget(
                  iconAssetPath:
                      'assets/svgs/doctor_icon_prepare_medical_report.svg',
                  label: S.of(context).prepareMedicalReportAction,
                  backgroundColor:
                      AppColorsManager.videoCallMedicalReportTileBackground,
                  iconColor: AppColorsManager.consultationBadgeText,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: VideoCallActionTileWidget(
                  iconAssetPath: 'assets/svgs/doctor_icon_medical_file.svg',
                  label: S.of(context).medicalFileAction,
                  backgroundColor:
                      AppColorsManager.videoCallMedicalFileTileBackground,
                  iconColor: AppColorsManager.basicDataGreenBadgeIcon,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VideoCallActionTileWidget(
                  iconAssetPath: 'assets/svgs/doctor_icon_bookings.svg',
                  label: S.of(context).bookingsTitle,
                  backgroundColor:
                      AppColorsManager.videoCallBookingsTileBackground,
                  iconColor: AppColorsManager.homeViewsCardMetricText,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: VideoCallActionTileWidget(
                  iconAssetPath: 'assets/svgs/doctor_icon_prescription.svg',
                  label: S.of(context).prescriptionAction,
                  backgroundColor:
                      AppColorsManager.videoCallPrescriptionTileBackground,
                  iconColor: AppColorsManager.basicDataRoseBadgeIcon,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
