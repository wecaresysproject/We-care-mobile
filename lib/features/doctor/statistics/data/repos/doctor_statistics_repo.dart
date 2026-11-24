import 'package:dio/dio.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/statistics/data/doctor_statistics_dev_mock.dart';
import 'package:we_care/features/doctor/statistics/data/models/doctor_statistics_model.dart';

/// "إحصائيات" (docs/doctor_app_ui_updates_backend.md, section 3).
class DoctorStatisticsRepo {
  DoctorStatisticsRepo(this._doctorServices);

  final DoctorServices _doctorServices;

  /// [month] is 1–12.
  Future<ApiResult<DoctorStatisticsModel>> getStatistics({
    required int month,
    required int year,
  }) async {
    try {
      final response = await _doctorServices.getStatistics(month, year);
      final data = response is Map ? response['data'] : null;
      return ApiResult.success(
        DoctorStatisticsModel.fromJson(
          data is Map ? Map<String, dynamic>.from(data) : const {},
        ),
      );
    } catch (error) {
      // TODO(statistics): remove with DoctorStatisticsDevMock.
      if (DoctorStatisticsDevMock.enabled &&
          error is DioException &&
          error.response?.statusCode == 404) {
        return ApiResult.success(
          DoctorStatisticsDevMock.build(month: month, year: year),
        );
      }
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
