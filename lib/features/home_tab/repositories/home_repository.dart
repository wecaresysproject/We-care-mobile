import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/home_tab/models/message_notification_model.dart';
import 'package:we_care/features/home_tab/services/home_service.dart';

class HomeRepository {
  final HomeService _homeService;

  HomeRepository(this._homeService);

  Future<ApiResult<List<CrausalMessageModel>>> getMessageNotifications() async {
    try {
      final response = await _homeService.getMessageNotifications(
        'Patient',
        'ar',
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        final notifications = data.map((e) => CrausalMessageModel.fromJson(e)).toList();
        return ApiResult.success(notifications);
      } else {
        return ApiResult.success([]);
      }
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
