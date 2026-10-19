import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/bookings/data/models/bookings_model.dart';
import 'package:we_care/features/doctor/bookings/data/models/today_appointment_model.dart';
import 'package:we_care/features/doctor/bookings/data/models/waiting_patient_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';

class BookingsRepo {
  final DoctorServices _doctorServices;

  BookingsRepo(this._doctorServices);

  Future<ApiResult<BookingsModel>> getBookings() async {
    try {
      final response = await _doctorServices.getDoctorBookings();
      return ApiResult.success(
        BookingsModel.fromJson(response['data'] as Map<String, dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Accepts [patient] and returns them as a today's-appointment row as the
  /// API confirms it — or, when the response carries no row, one built from
  /// the waiting entry starting now.
  Future<ApiResult<TodayAppointmentModel>> acceptWaitingPatient(
    WaitingPatientModel patient,
  ) async {
    try {
      final response = await _doctorServices.acceptWaitingPatient(patient.id);
      final data = response is Map ? response['data'] : null;
      return ApiResult.success(
        data is Map<String, dynamic> && data['startsAt'] is String
            // The accept response may omit the patient fields — keep the
            // waiting entry's name/photo in that case.
            ? TodayAppointmentModel.fromJson({
                'patientName': patient.patientName,
                'patientImageUrl': patient.patientPhotoUrl,
                ...data,
              })
            : TodayAppointmentModel(
                id: patient.id,
                patientName: patient.patientName,
                patientPhotoUrl: patient.patientPhotoUrl,
                type: patient.type,
                startsAt: DateTime.now(),
              ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> rejectWaitingPatient(String bookingId) async {
    try {
      await _doctorServices.rejectWaitingPatient(bookingId);
      return const ApiResult.success(true);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
