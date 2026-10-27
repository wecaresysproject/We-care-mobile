import 'package:flutter/material.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/call_participant_role.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

/// بيفتح مكالمة الاستشارة من رسالة "بدأت الاستشارة" (الإشعار أو صفحة
/// الرسائل) — المريض على شاشة مكالمته الكاملة، والشخص المقرب على شاشة
/// المشارك البسيطة. الدور بييجى من `GET /Video`.
class ConsultationCallLauncher {
  ConsultationCallLauncher._();

  static bool _isOpening = false;

  static Future<void> open(
    NavigatorState navigator, {
    required String appointmentId,
  }) async {
    if (_isOpening || appointmentId.isEmpty) return;
    _isOpening = true;

    final repo = getIt<OnlineDoctorRepo>();
    _showLoading(navigator.context);
    final meetingResult =
        await repo.getVideoMeeting(appointmentId: appointmentId);

    final role = meetingResult.when(
      success: (meeting) => meeting?.role ?? CallParticipantRole.participant,
      failure: (error) {
        showError(error.errors.first);
        return null;
      },
    );

    if (role != CallParticipantRole.patient) {
      navigator.pop(); // loading dialog
      _isOpening = false;
      if (role == null) return;
      navigator.pushNamed(Routes.participantCallView, arguments: appointmentId);
      return;
    }

    // شاشة المريض محتاجة الحجز نفسه (الطبيب ونوع الموعد).
    final roomResult = await repo.getAppointmentRoom(bookingId: appointmentId);
    navigator.pop(); // loading dialog
    _isOpening = false;
    roomResult.when(
      success: (room) => navigator.pushNamed(
        Routes.examinationCallView,
        arguments: room.booking,
      ),
      failure: (error) => showError(error.errors.first),
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
