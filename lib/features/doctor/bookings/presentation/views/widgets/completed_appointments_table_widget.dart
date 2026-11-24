import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';
import 'package:we_care/features/doctor/bookings/data/models/completed_appointment_model.dart';

/// "الكشوفات المنتهية": a simple table of today's finished sessions —
/// patient, time and type.
///
/// The screen is laid out left to right (see BookingsView), so the cells
/// are listed from the left: type, time, then the patient on the right.
class CompletedAppointmentsTableWidget extends StatelessWidget {
  const CompletedAppointmentsTableWidget({
    super.key,
    required this.appointments,
  });

  final List<CompletedAppointmentModel> appointments;

  static const _typeFlex = 3;
  static const _timeFlex = 3;
  static const _patientFlex = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: appointments.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Center(
                child: Text(
                  "لا توجد كشوفات منتهية اليوم",
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.font13GreyWeight400,
                ),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Column(
                children: [
                  _headerRow(),
                  for (var i = 0; i < appointments.length; i++)
                    _row(appointments[i], isLast: i == appointments.length - 1),
                ],
              ),
            ),
    );
  }

  Widget _headerRow() {
    final style = AppTextStyles.font12Weight600.copyWith(
      color: AppColorsManager.mainDarkBlue,
    );
    return Container(
      color: AppColorsManager.examinationBadgeBackground,
      padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 10.w),
      child: Row(
        children: [
          Expanded(
            flex: _typeFlex,
            child: Text("النوع", textAlign: TextAlign.center, style: style),
          ),
          Expanded(
            flex: _timeFlex,
            child: Text("التوقيت", textAlign: TextAlign.center, style: style),
          ),
          Expanded(
            flex: _patientFlex,
            child: Text("المريض", textAlign: TextAlign.right, style: style),
          ),
        ],
      ),
    );
  }

  Widget _row(CompletedAppointmentModel appointment, {required bool isLast}) {
    final isExamination = appointment.type == AppointmentType.examination;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: AppColorsManager.shimmerBase),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: _typeFlex,
            child: Text(
              isExamination ? "كشف" : "استشارة",
              textAlign: TextAlign.center,
              style: AppTextStyles.font12Weight600.copyWith(
                color: isExamination
                    ? AppColorsManager.examinationBadgeText
                    : AppColorsManager.consultationBadgeText,
              ),
            ),
          ),
          Expanded(
            flex: _timeFlex,
            child: Text(
              appointment.bookingTimeLabel,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.font13GreyWeight400,
            ),
          ),
          Expanded(
            flex: _patientFlex,
            child: Text(
              appointment.patientName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.font14blackWeight600,
            ),
          ),
        ],
      ),
    );
  }
}
