import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/research_and_papers/data/models/research_papers_request_body_model.dart';

class ResearchAndPapersRepo {
  final DoctorServices _doctorServices;

  ResearchAndPapersRepo(this._doctorServices);

  Future<ApiResult<String>> submitResearchPapers(
    ResearchPapersRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postResearchPapers(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
