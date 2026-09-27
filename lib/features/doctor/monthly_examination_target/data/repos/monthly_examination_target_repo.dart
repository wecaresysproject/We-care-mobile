import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/monthly_examination_target/data/models/monthly_examination_target_model.dart';

/// TODO: no backend contract exists yet for the doctor "monthly examination
/// target" feature — confirm the endpoints (fetch history + current goal,
/// submit a new monthly goal) and request/response shape, then replace the
/// mocked data below with real Retrofit service calls (see `AppSharedRepo`
/// for the wrapping pattern). Method signatures are kept identical to what a
/// real implementation would expose so swapping the mocked body for a
/// service call is a one-file change.
class MonthlyExaminationTargetRepo {
  /// Returns the monthly-target history, most recent month first. The first
  /// entry is treated as the current month's goal/progress.
  Future<ApiResult<List<MonthlyExaminationTargetModel>>>
      getMonthlyTargetHistory() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return ApiResult.success(_mockedHistory);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Persists the doctor's chosen monthly goal count.
  Future<ApiResult<String>> submitMonthlyTarget(int goalCount) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return const ApiResult.success('تم حفظ الإعدادات بنجاح');
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  static final List<MonthlyExaminationTargetModel> _mockedHistory = [
    MonthlyExaminationTargetModel(
      id: '1',
      monthName: 'أغسطس',
      year: 2025,
      goalCount: 50,
      achievedCount: 32,
    ),
    MonthlyExaminationTargetModel(
      id: '2',
      monthName: 'يوليو',
      year: 2025,
      goalCount: 50,
      achievedCount: 45,
    ),
    MonthlyExaminationTargetModel(
      id: '3',
      monthName: 'يونيو',
      year: 2025,
      goalCount: 50,
      achievedCount: 38,
    ),
    MonthlyExaminationTargetModel(
      id: '4',
      monthName: 'مايو',
      year: 2025,
      goalCount: 50,
      achievedCount: 28,
    ),
  ];
}
