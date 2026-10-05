import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/monthly_examination_target/data/models/monthly_examination_target_model.dart';

class MonthlyExaminationTargetRepo {
  final DoctorServices _doctorServices;

  MonthlyExaminationTargetRepo(this._doctorServices);

  /// Returns the monthly-target history, most recent month first. The first
  /// entry is treated as the current month's goal/progress.
  Future<ApiResult<List<MonthlyExaminationTargetModel>>>
      getMonthlyTargetHistory() async {
    try {
      final response = await _doctorServices.getMonthlyExaminationTargets();
      final history = (response['data'] as List? ?? const [])
          .map(
            (e) => MonthlyExaminationTargetModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
      return ApiResult.success(history);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Persists the doctor's chosen monthly goal count.
  Future<ApiResult<String>> submitMonthlyTarget(int goalCount) async {
    try {
      final response = await _doctorServices.postMonthlyExaminationTarget(
        {'goalCount': goalCount},
      );
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ الإعدادات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
