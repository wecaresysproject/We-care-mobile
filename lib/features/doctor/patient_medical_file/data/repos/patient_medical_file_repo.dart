import 'package:dio/dio.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_error_model.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/patient_medical_file/data/models/booking_patient_access_model.dart';

class PatientMedicalFileRepo {
  final DoctorServices _doctorServices;

  PatientMedicalFileRepo(this._doctorServices);

  /// The modules the patient of [bookingId] allowed, and until when.
  Future<ApiResult<BookingPatientAccessModel>> getBookingPatientAccess(
    String bookingId,
  ) async {
    try {
      final response = await _doctorServices.getBookingPatientAccess(bookingId);
      return ApiResult.success(
        BookingPatientAccessModel.fromJson(
          response['data'] as Map<String, dynamic>,
        ),
      );
    } catch (error) {
      final denied = _deniedError(error);
      if (denied != null) return ApiResult.failure(denied);
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// The server answers 403 with an English `message`: with `data` when the
  /// access window has expired, without it when the booking isn't this
  /// doctor's. Show Arabic text instead.
  static ApiErrorModel? _deniedError(Object error) {
    if (error is! DioException || error.response?.statusCode != 403) {
      return null;
    }
    final body = error.response?.data;
    final expired = body is Map && body['data'] is Map;
    return ApiErrorModel(
      success: false,
      errors: [
        expired
            ? 'انتهت صلاحية الوصول لملف المريض'
            : 'غير مصرح لك بالوصول لملف هذا المريض',
      ],
    );
  }
}
