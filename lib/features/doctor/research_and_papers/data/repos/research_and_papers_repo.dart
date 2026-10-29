import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';
import 'package:we_care/features/doctor/research_and_papers/data/models/research_paper_model.dart';
import 'package:we_care/features/doctor/research_and_papers/data/models/research_papers_request_body_model.dart';

class ResearchAndPapersRepo {
  final DoctorServices _doctorServices;

  ResearchAndPapersRepo(this._doctorServices);

  /// The doctor's saved research papers; empty when the module wasn't filled yet.
  Future<ApiResult<List<ResearchPaperModel>>> getResearchPapers() async {
    try {
      final response = await _doctorServices.getResearchPapers();
      final data = profileResponseData(response);
      if (data is! Map<String, dynamic>) return ApiResult.success(const []);
      return ApiResult.success(
          ResearchPapersRequestBodyModel.fromJson(data).researchPapers);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

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
