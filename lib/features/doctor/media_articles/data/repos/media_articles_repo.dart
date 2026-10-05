import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/media_articles/data/models/media_articles_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';

class MediaArticlesRepo {
  final DoctorServices _doctorServices;

  MediaArticlesRepo(this._doctorServices);

  Future<ApiResult<String>> submitMediaArticles(
    MediaArticlesRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postMediaArticles(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
