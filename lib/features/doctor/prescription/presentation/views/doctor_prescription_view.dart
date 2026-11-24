import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/doctor/prescription/logic/cubit/doctor_prescription_cubit.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_diagnosis_card_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_examinations_section_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_instructions_section_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_medicines_section_widget.dart';

/// What `Routes.doctorPrescriptionView` takes.
class DoctorPrescriptionViewArgs {
  const DoctorPrescriptionViewArgs({
    required this.bookingId,
    this.patientName,
  });

  final String bookingId;
  final String? patientName;
}

/// The prescription the doctor writes for the patient during the call.
/// Expects a [DoctorPrescriptionCubit] above it that is loading the
/// booking's prescription (see `AppRouter`).
class DoctorPrescriptionView extends StatelessWidget {
  const DoctorPrescriptionView({
    super.key,
    required this.bookingId,
    this.patientName,
  });

  final String bookingId;

  /// Shown in the patient card — hidden when unknown.
  final String? patientName;

  @override
  Widget build(BuildContext context) {
    final loadStatus = context.select<DoctorPrescriptionCubit, RequestStatus>(
      (cubit) => cubit.state.loadStatus,
    );

    return BlocListener<DoctorPrescriptionCubit, DoctorPrescriptionState>(
      listenWhen: (previous, current) =>
          current.message != null &&
          previous.saveStatus != current.saveStatus &&
          (current.saveStatus == RequestStatus.success ||
              current.saveStatus == RequestStatus.failure),
      listener: (context, state) => state.saveStatus == RequestStatus.success
          ? showSuccess(state.message!)
          : showError(state.message!),
      child: Scaffold(
        backgroundColor: AppColorsManager.prescriptionScaffoldBackground,
        body: SafeArea(
          child: switch (loadStatus) {
            RequestStatus.success => _PrescriptionForm(
                patientName: patientName?.trim() ?? '',
              ),
            RequestStatus.failure => _LoadError(
                onRetry: () =>
                    context.read<DoctorPrescriptionCubit>().loadPrescription(
                          bookingId: bookingId,
                          patientName: patientName,
                        ),
              ),
            _ => const Column(
                children: [
                  _PrescriptionHeader(),
                  Expanded(child: Center(child: CircularProgressIndicator())),
                ],
              ),
          },
        ),
      ),
    );
  }
}

class _PrescriptionForm extends StatelessWidget {
  const _PrescriptionForm({required this.patientName});

  final String patientName;

  @override
  Widget build(BuildContext context) {
    final name = patientName;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PrescriptionHeader(),
          verticalSpacing(16),
          const _SavedNotice(),
          if (name.isNotEmpty) ...[
            _PatientCard(name: name),
            verticalSpacing(14),
          ],
          const PrescriptionDiagnosisCardWidget(),
          verticalSpacing(14),
          const PrescriptionMedicinesSectionWidget(),
          verticalSpacing(14),
          const PrescriptionExaminationsSectionWidget(),
          verticalSpacing(14),
          const PrescriptionInstructionsSectionWidget(),
          verticalSpacing(24),
          const _PrescriptionActions(),
        ],
      ),
    );
  }
}

/// Shown once the prescription was sent: the patient already has it, and
/// saving again replaces it.
class _SavedNotice extends StatelessWidget {
  const _SavedNotice();

  @override
  Widget build(BuildContext context) {
    final (createdAt, editedAt) =
        context.select<DoctorPrescriptionCubit, (DateTime?, DateTime?)>(
      (cubit) => (cubit.state.createdAt, cubit.state.editedAt),
    );
    if (createdAt == null) return const SizedBox.shrink();

    final lastSave = editedAt ?? createdAt;
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColorsManager.examinationBadgeBackground,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 20.r,
              color: AppColorsManager.examinationBadgeText,
            ),
            horizontalSpacing(8),
            Expanded(
              child: Text(
                "${editedAt == null ? 'تم إرسال الروشتة للمريض' : 'آخر تعديل'}"
                " ${_formatDateTime(lastSave)} — أي حفظ جديد يحدّثها عند المريض",
                style: AppTextStyles.font13GreyWeight400.copyWith(
                  color: AppColorsManager.examinationBadgeText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDateTime(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final period = value.hour < 12 ? 'ص' : 'م';
    return "${value.year}/${two(value.month)}/${two(value.day)}"
        " $hour:${two(value.minute)} $period";
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message = context.select<DoctorPrescriptionCubit, String?>(
      (cubit) => cubit.state.message,
    );

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          child: const _PrescriptionHeader(),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message ?? "تعذر تحميل الروشتة",
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
          ),
        ),
      ],
    );
  }
}

/// "معاينة الروشتة" and "حفظ وإرسال" — enabled once anything is written.
class _PrescriptionActions extends StatelessWidget {
  const _PrescriptionActions();

  @override
  Widget build(BuildContext context) {
    final (isEmpty, isSaving, isSaved) =
        context.select<DoctorPrescriptionCubit, (bool, bool, bool)>(
      (cubit) => (
        cubit.state.isEmpty,
        cubit.state.saveStatus == RequestStatus.loading,
        cubit.state.isSaved,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: isEmpty || isSaving
              ? null
              : () => Navigator.of(context).pushNamed(
                    Routes.doctorPrescriptionPreviewView,
                    arguments:
                        context.read<DoctorPrescriptionCubit>().documentData(),
                  ),
          icon: const Icon(Icons.visibility_outlined),
          label: const Text("معاينة الروشتة"),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColorsManager.prescriptionActionBlue,
            side: const BorderSide(
              color: AppColorsManager.prescriptionActionBlue,
            ),
            minimumSize: Size.fromHeight(48.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            textStyle: AppTextStyles.font16BlackSemiBold,
          ),
        ),
        verticalSpacing(12),
        AppCustomButton(
          title: isSaved ? "حفظ التعديلات وإرسال" : "حفظ وإرسال",
          icon: Icons.send_outlined,
          textFontSize: 18,
          isEnabled: !isEmpty,
          isLoading: isSaving,
          onPressed: context.read<DoctorPrescriptionCubit>().savePrescription,
        ),
      ],
    );
  }
}

class _PrescriptionHeader extends StatelessWidget {
  const _PrescriptionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Balances the close button so the title stays centered.
        SizedBox(width: 48.w),
        Expanded(
          child: Column(
            children: [
              Text(
                "الروشتة / وصفة طبية",
                textAlign: TextAlign.center,
                style: AppTextStyles.font20blackWeight700.copyWith(
                  color: AppColorsManager.prescriptionTitleColor,
                ),
              ),
              verticalSpacing(4),
              Text(
                "أضف تفاصيل الروشتة للمريض",
                textAlign: TextAlign.center,
                style: AppTextStyles.font13GreyWeight400.copyWith(
                  color: AppColorsManager.prescriptionSubtitleColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 48.w,
          child: IconButton(
            tooltip: "إغلاق",
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color: AppColorsManager.prescriptionTitleColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColorsManager.prescriptionCardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColorsManager.examinationBadgeBackground,
              shape: BoxShape.circle,
            ),
            child: Text(
              name.characters.first,
              style: AppTextStyles.font20blackWeight700.copyWith(
                color: AppColorsManager.examinationBadgeText,
              ),
            ),
          ),
          horizontalSpacing(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font16BlackSemiBold.copyWith(
                    color: AppColorsManager.prescriptionTitleColor,
                  ),
                ),
                verticalSpacing(2),
                Text(
                  "المريض",
                  style: AppTextStyles.font13GreyWeight400.copyWith(
                    color: AppColorsManager.prescriptionSubtitleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
