import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/patient_files/data/models/patient_file_models.dart';

const _navy = AppColorsManager.prescriptionTitleColor;
const _muted = AppColorsManager.prescriptionSubtitleColor;
const _blue = AppColorsManager.prescriptionActionBlue;
const _chip = Color(0xFFE6EEFB);
const _expiryRed = Color(0xFFDC2626);

/// "15/11/2025".
String patientFileDateLabel(DateTime? date) => date == null
    ? "—"
    : "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/${date.year}";

/// What's left of the access window: "3 أيام", "2 يوم", "5 ساعة".
String remainingAccessLabel(DateTime? expiresAt, DateTime now) {
  if (expiresAt == null || !now.isBefore(expiresAt)) return "انتهت";
  final left = expiresAt.difference(now);
  if (left.inHours < 1) return "أقل من ساعة";
  if (left.inHours < 24) return "${left.inHours} ساعة";
  final days = (left.inHours / 24).ceil();
  return days >= 3 && days <= 10 ? "$days أيام" : "$days يوم";
}

/// One row of "ملفات مفتوحة بالصلاحية". The folder opens the patient's
/// medical file, limited to the modules the patient allowed.
class OpenPatientFileCard extends StatelessWidget {
  const OpenPatientFileCard({
    super.key,
    required this.file,
    required this.now,
    required this.onOpenFile,
  });

  final OpenPatientFileModel file;
  final DateTime now;
  final VoidCallback onOpenFile;

  @override
  Widget build(BuildContext context) {
    return _PatientCardShell(
      patient: file.patient,
      details: [
        _Detail(
          flex: 4,
          icon: Icons.calendar_month_outlined,
          label: "تاريخ الكشف",
          value: Text(patientFileDateLabel(file.examinationDate),
              style: _valueStyle),
        ),
        _Detail(
          icon: Icons.person_outline_rounded,
          label: "العمر",
          value: Text(_ageLabel(file.patient.age), style: _valueStyle),
        ),
        _Detail(
          label: "حالة الكشف",
          value: _Chip(file.status.label),
        ),
      ],
      action: _CardAction(
        onTap: onOpenFile,
        children: [
          Image.asset(
            'assets/images/doctor_action_patient_files.png',
            width: 50.r,
            height: 50.r,
          ),
          verticalSpacing(4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_rounded, size: 12.r, color: _expiryRed),
              horizontalSpacing(2),
              Text(
                "الصلاحية",
                style: AppTextStyles.font14blackWeight400.copyWith(
                  fontSize: 10.sp,
                  color: _navy,
                ),
              ),
            ],
          ),
          Text(
            remainingAccessLabel(file.accessExpiresAt, now),
            style: AppTextStyles.font14blackWeight400.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: _expiryRed,
            ),
          ),
        ],
      ),
    );
  }
}

/// One row of "ملفات المرضى القدامى". "الروشتات" opens what this doctor
/// wrote for the patient.
class PreviousPatientCard extends StatelessWidget {
  const PreviousPatientCard({
    super.key,
    required this.patient,
    required this.onOpenPrescriptions,
  });

  final PreviousPatientModel patient;
  final VoidCallback onOpenPrescriptions;

  @override
  Widget build(BuildContext context) {
    final country = patient.patient.country;
    return _PatientCardShell(
      patient: patient.patient,
      details: [
        _Detail(
          flex: 4,
          icon: Icons.calendar_month_outlined,
          label: "تاريخ آخر كشف",
          value: Text(patientFileDateLabel(patient.lastExaminationDate),
              style: _valueStyle),
        ),
        _Detail(
          icon: Icons.person_outline_rounded,
          label: "العمر",
          value: Text(_ageLabel(patient.patient.age), style: _valueStyle),
        ),
        _Detail(
          icon: Icons.flag_outlined,
          label: country.isEmpty ? "البلد" : "البلد: $country",
          value: _Chip(patient.lastType.label),
        ),
      ],
      action: _CardAction(
        onTap: onOpenPrescriptions,
        children: [
          Icon(Icons.receipt_long_rounded, size: 44.r, color: _muted),
          verticalSpacing(4),
          Text(
            "الروشتات",
            style: AppTextStyles.font14blackWeight400.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: _muted,
            ),
          ),
        ],
      ),
    );
  }
}

String _ageLabel(int? age) => age == null ? "—" : "$age سنة";

TextStyle get _valueStyle => AppTextStyles.font14blackWeight400.copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      color: _navy,
    );

class _PatientCardShell extends StatelessWidget {
  const _PatientCardShell({
    required this.patient,
    required this.details,
    required this.action,
  });

  final PatientFilePatientModel patient;
  final List<_Detail> details;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final photo = patient.photoUrl;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColorsManager.prescriptionCardBorder),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 19.r,
                        backgroundColor:
                            AppColorsManager.prescriptionCardBorder,
                        backgroundImage: photo == null
                            ? const AssetImage('assets/images/user_avatar.png')
                            : NetworkImage(photo) as ImageProvider,
                      ),
                      horizontalSpacing(10),
                      Expanded(
                        child: Text(
                          patient.name.isEmpty ? "مريض" : patient.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.font16BlackSemiBold.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: _navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing(10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final detail in details)
                        Expanded(flex: detail.flex, child: detail),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              color: AppColorsManager.prescriptionCardBorder,
            ),
            action,
          ],
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({
    this.icon,
    required this.label,
    required this.value,
    this.flex = 3,
  });

  final IconData? icon;

  /// Share of the card's width — the date column gets more room.
  final int flex;
  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13.r, color: _blue),
              horizontalSpacing(3),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font14blackWeight400.copyWith(
                  fontSize: 10.sp,
                  color: _muted,
                ),
              ),
            ),
          ],
        ),
        verticalSpacing(4),
        value,
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: _chip,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: AppTextStyles.font14blackWeight400.copyWith(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: _navy,
        ),
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  const _CardAction({required this.onTap, required this.children});

  final VoidCallback onTap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          width: 72.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
