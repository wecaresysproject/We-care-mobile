import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/doctor/prescription/data/models/previous_prescription_model.dart';
import 'package:we_care/features/doctor/prescription/logic/cubit/previous_prescriptions_cubit.dart';

/// "روشتات المريض" — opened from "الروشتات القديمة" on the call screen.
/// Lists what the doctor wrote for this patient in earlier bookings; "عرض
/// الروشتة" opens that prescription's pages. Expects a
/// [PreviousPrescriptionsCubit] above it (see `AppRouter`).
class DoctorPreviousPrescriptionsView extends StatelessWidget {
  const DoctorPreviousPrescriptionsView({super.key, required this.args});

  final PreviousPrescriptionsArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            BlocBuilder<PreviousPrescriptionsCubit, PreviousPrescriptionsState>(
          builder: (context, state) {
            final data = state.data;
            return Column(
              children: [
                const _Header(),
                Expanded(
                  child: switch (state.status) {
                    RequestStatus.success when data != null =>
                      _PrescriptionsList(data: data),
                    RequestStatus.failure => _Message(
                        text: state.message ?? "تعذر تحميل الروشتات",
                        onRetry: () => context
                            .read<PreviousPrescriptionsCubit>()
                            .load(args),
                      ),
                    _ => const Center(child: CircularProgressIndicator()),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "روشتات المريض",
              style: AppTextStyles.font20blackWeight700.copyWith(
                fontSize: 18.sp,
                color: AppColorsManager.prescriptionTitleColor,
              ),
            ),
          ),
          Material(
            color: AppColorsManager.prescriptionScaffoldBackground,
            shape: const CircleBorder(
              side: BorderSide(color: AppColorsManager.prescriptionCardBorder),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: Icon(
                  // Points left like the design, not mirrored for RTL.
                  Icons.keyboard_arrow_left_rounded,
                  size: 22.r,
                  color: AppColorsManager.prescriptionTitleColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionsList extends StatelessWidget {
  const _PrescriptionsList({required this.data});

  final PreviousPrescriptionsModel data;

  @override
  Widget build(BuildContext context) {
    final prescriptions = data.prescriptions;
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      children: [
        _PatientCard(patient: data.patient),
        verticalSpacing(14),
        if (prescriptions.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 48.h),
            child: Text(
              "لا توجد روشتات سابقة لهذا المريض",
              textAlign: TextAlign.center,
              style: AppTextStyles.font16BlackSemiBold.copyWith(
                color: AppColorsManager.prescriptionSubtitleColor,
              ),
            ),
          ),
        for (var i = 0; i < prescriptions.length; i++) ...[
          if (i != 0) verticalSpacing(12),
          _PrescriptionCard(
            prescription: prescriptions[i],
            onView: () => Navigator.of(context).pushNamed(
              Routes.doctorPrescriptionCopyView,
              arguments: prescriptions[i].images,
            ),
          ),
        ],
      ],
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.patient});

  final PrescriptionPatientModel patient;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (patient.age != null)
        (Icons.person_outline_rounded, "${patient.age} سنة"),
      if (patient.country.isNotEmpty) (Icons.public_rounded, patient.country),
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF4FE),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            patient.name.isEmpty ? "المريض" : patient.name,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16BlackSemiBold.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColorsManager.prescriptionTitleColor,
            ),
          ),
          if (details.isNotEmpty) ...[
            verticalSpacing(6),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 18.w,
              runSpacing: 4.h,
              children: [
                for (final (icon, label) in details)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 15.r,
                        color: AppColorsManager.prescriptionActionBlue,
                      ),
                      horizontalSpacing(4),
                      Text(
                        label,
                        style: AppTextStyles.font14blackWeight400.copyWith(
                          fontSize: 12.sp,
                          color: AppColorsManager.prescriptionSubtitleColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  const _PrescriptionCard({required this.prescription, required this.onView});

  final PreviousPrescriptionModel prescription;
  final VoidCallback onView;

  /// "10/11/2026", like the design.
  static String _dateLabel(DateTime date) =>
      "${date.day.toString().padLeft(2, '0')}/"
      "${date.month.toString().padLeft(2, '0')}/${date.year}";

  @override
  Widget build(BuildContext context) {
    final date = prescription.date;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColorsManager.prescriptionCardBorder),
        boxShadow: [
          BoxShadow(
            color:
                AppColorsManager.prescriptionTitleColor.withValues(alpha: 0.05),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    icon: Icons.calendar_month_outlined,
                    label: "التاريخ",
                    child: Text(
                      date == null ? "—" : _dateLabel(date),
                      style: AppTextStyles.font14blackWeight400.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColorsManager.prescriptionTitleColor,
                      ),
                    ),
                  ),
                  verticalSpacing(10),
                  const _InfoRow(
                    icon: Icons.medical_services_outlined,
                    label: "التشخيص",
                    child: SizedBox.shrink(),
                  ),
                  verticalSpacing(6),
                  // Under the label at full width, so a long diagnosis wraps
                  // over as many lines as it needs.
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF4FE),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      prescription.diagnosis.isEmpty
                          ? "بدون تشخيص"
                          : prescription.diagnosis,
                      style: AppTextStyles.font14blackWeight400.copyWith(
                        fontSize: 12.sp,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                        color: AppColorsManager.prescriptionTitleColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              color: AppColorsManager.prescriptionCardBorder,
            ),
            Center(
              child: Material(
                color: const Color(0xFFEDF4FE),
                borderRadius: BorderRadius.circular(12.r),
                child: InkWell(
                  onTap: onView,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 22.r,
                          color: AppColorsManager.prescriptionActionBlue,
                        ),
                        verticalSpacing(4),
                        Text(
                          "الروشتة",
                          style: AppTextStyles.font14blackWeight400.copyWith(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColorsManager.prescriptionActionBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: AppColorsManager.prescriptionActionBlue),
        horizontalSpacing(6),
        Text(
          label,
          style: AppTextStyles.font14blackWeight400.copyWith(
            fontSize: 12.sp,
            color: AppColorsManager.prescriptionSubtitleColor,
          ),
        ),
        horizontalSpacing(10),
        child,
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.onRetry});

  final String text;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.font16BlackSemiBold.copyWith(
                color: AppColorsManager.prescriptionTitleColor,
              ),
            ),
            verticalSpacing(8),
            TextButton(
              onPressed: onRetry,
              child: const Text("إعادة المحاولة"),
            ),
          ],
        ),
      ),
    );
  }
}
