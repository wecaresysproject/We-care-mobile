import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/research_and_papers/data/models/research_papers_request_body_model.dart';

/// TODO: no backend contract exists yet for submitting the doctor
/// "research and papers" form — confirm the endpoint and request/response
/// shape, then replace this stub with a real Retrofit service call (see
/// `AppSharedRepo` for the wrapping pattern).
class ResearchAndPapersRepo {
  Future<ApiResult<String>> submitResearchPapers(
    ResearchPapersRequestBodyModel model,
  ) async {
    try {
      throw UnimplementedError(
        'Research and papers submission endpoint is not defined yet.',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
