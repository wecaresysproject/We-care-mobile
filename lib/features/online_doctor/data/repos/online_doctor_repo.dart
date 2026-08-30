import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_summary_model.dart';
import 'package:we_care/features/online_doctor/online_doctor_services.dart';

class OnlineDoctorRepo {
  final OnlineDoctorServices _onlineDoctorServices;

  OnlineDoctorRepo({required OnlineDoctorServices onlineDoctorServices})
      : _onlineDoctorServices = onlineDoctorServices;

  Future<ApiResult<List<DoctorSummaryModel>>> getDoctorsBySpecialty({
    required String specialty,
  }) async {
    try {
      final response =
          await _onlineDoctorServices.getDoctorsBySpecialty(specialty);
      final doctors = (response['data'] as List? ?? const [])
          .map((e) => DoctorSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(doctors);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<DoctorModel>> getDoctorProfile({
    required String doctorId,
  }) async {
    try {
      final response = await _onlineDoctorServices.getDoctorProfile(doctorId);
      return ApiResult.success(
        DoctorModel.fromJson(response['data'] as Map<String, dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// بيضيف الطبيب للمفضلة لو [isFavorite] = `true` أو بيشيله لو `false`،
  /// وبيرجّع الحالة النهائية زى ما الـ API بيأكدها.
  Future<ApiResult<bool>> setDoctorFavorite({
    required String doctorId,
    required bool isFavorite,
  }) async {
    try {
      final response = isFavorite
          ? await _onlineDoctorServices.addDoctorToFavorites(doctorId)
          : await _onlineDoctorServices.removeDoctorFromFavorites(doctorId);
      final data = response is Map ? response['data'] : null;
      final confirmed = data is Map ? data['isFavorite'] : null;
      return ApiResult.success(confirmed is bool ? confirmed : isFavorite);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
