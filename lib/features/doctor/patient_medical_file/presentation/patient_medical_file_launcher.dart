import 'dart:async';

import 'package:flutter/material.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/core/networking/models/care_context_manager_model.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/doctor/patient_medical_file/data/models/booking_patient_access_model.dart';
import 'package:we_care/features/doctor/patient_medical_file/data/repos/patient_medical_file_repo.dart';

/// Opens the medical file of a booking's patient for the doctor, read-only
/// and limited to the modules the patient allowed. Used from the video call
/// and the bookings screen.
///
/// It reuses care mode: the doctor lands on the patient's medical categories
/// screen, locked modules show dimmed, and every request carries the
/// `Active-Medical-Profile` header.
class PatientMedicalFileLauncher {
  PatientMedicalFileLauncher._();

  static const expiredMessage = 'انتهت صلاحية الوصول لملف المريض';
  static const noAccessMessage = 'المريض لم يسمح بالوصول لملفه الطبي';

  static String moduleNotAllowedMessage(MedicalModule module) =>
      'المريض لم يسمح بالوصول إلى ${module.nameAr}';

  static bool _isOpening = false;

  /// [route] is the patient screen to open (the medical file by default, or
  /// the medical report / medicines compatibility). When [requiredModule] is
  /// set, the screen only opens if the patient allowed that module.
  static Future<void> open(
    BuildContext context, {
    required String bookingId,
    String route = Routes.medicalCategoriesTypesView,
    MedicalModule? requiredModule,
  }) async {
    if (_isOpening || CareContextManager.isCareModeActive) return;
    _isOpening = true;

    final navigator = Navigator.of(context);
    final returnRoute = ModalRoute.of(context);

    _showLoading(context);
    final result = await getIt<PatientMedicalFileRepo>()
        .getBookingPatientAccess(bookingId);
    navigator.pop(); // loading dialog
    _isOpening = false;

    final access = result.when(
      success: (access) => access,
      failure: (error) {
        showError(error.errors.first);
        return null;
      },
    );
    if (access == null) return;
    if (access.isExpired) {
      showError(expiredMessage);
      return;
    }
    if (!access.hasAnyModule) {
      showError(noAccessMessage);
      return;
    }
    if (requiredModule != null && !access.allows(requiredModule)) {
      showError(moduleNotAllowedMessage(requiredModule));
      return;
    }

    Timer? expiryTimer;

    // Leaves the file and goes back to the screen that opened it — never
    // resets the stack, so a running call stays alive underneath.
    void close(String? reason) {
      if (!CareContextManager.isDoctorAccess) return;
      expiryTimer?.cancel();
      CareContextManager.exit();
      navigator.popUntil((route) => route == returnRoute || route.isFirst);
      if (reason != null) showError(reason);
    }

    _enterCareMode(bookingId, access, close);

    final expiresAt = access.expiresAt;
    if (expiresAt != null) {
      expiryTimer = Timer(
        expiresAt.difference(DateTime.now()),
        () => close(expiredMessage),
      );
    }

    await navigator.pushNamed(route);

    // Back on the opening screen (back arrow, banner or expiry).
    expiryTimer?.cancel();
    if (CareContextManager.isDoctorAccess) CareContextManager.exit();
  }

  static void _enterCareMode(
    String bookingId,
    BookingPatientAccessModel access,
    void Function(String? reason) onClose,
  ) {
    CareContextManager.enter(
      accessId: bookingId,
      patientId: access.patientId,
      patientName: access.patientName,
      modulePermissions: access.modulePermissions,
      source: CareAccessSource.doctorBooking,
      expiresAt: access.expiresAt,
      onClose: onClose,
    );
  }

  static void _showLoading(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
