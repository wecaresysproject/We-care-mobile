import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/core/networking/auth_service.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_comment_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_home_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_performance_metric_model.dart';

/// No doctor-dashboard endpoint exists yet — [getDoctorHome] returns fixed
/// mock data so the UI/Cubit layers are ready to swap in a real service call
/// once the backend contract is confirmed. [logout] uses the shared auth API.
class DoctorHomeRepo {
  final AuthApiServices _authApiServices;

  DoctorHomeRepo(this._authApiServices);

  Future<ApiResult<DoctorHomeModel>> getDoctorHome() async {
    return ApiResult.success(
      DoctorHomeModel(
        doctorName: 'د/أحمد محمود',
        specialty: 'استشارى جهاز مناعى',
        doctorPhotoUrl: 'assets/images/doctor_photo.png',
        clinicLogoUrl: 'assets/images/doctor_clinic_logo.png',
        waitingCount: 10,
        followUpsCount: 8,
        currentBookingsCount: 15,
        allowedBookingsCount: 20,
        dataCompletionPercentage: 50,
        achievedExaminationsCount: 8,
        monthlyTargetExaminationsCount: 10,
        yearlyTargetExaminationsCount: 600,
        appearances: DoctorPerformanceMetricModel(
          monthlyCount: 200,
          yearlyCount: 600,
        ),
        shares: DoctorPerformanceMetricModel(
          monthlyCount: 200,
          yearlyCount: 600,
        ),
        watches: DoctorPerformanceMetricModel(
          monthlyCount: 200,
          yearlyCount: 600,
        ),
        // Figma shows 3 carousel dots but only exported one ad creative —
        // repeated here as a placeholder until real ad content/assets exist.
        adBannerImageUrls: List.filled(3, 'assets/images/doctor_ad_banner.png'),
        commentsCount: 80,
        comments: [
          DoctorCommentModel(
            patientName: 'مصطفى عبدالله',
            comment:
                'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك أن تولد مثل هذا النص أو العديد',
          ),
          DoctorCommentModel(
            patientName: 'ندى كمال',
            comment:
                'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص',
          ),
          DoctorCommentModel(
            patientName: 'عمر حازم',
            comment:
                'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي،',
          ),
        ],
        ratingsCount: 150,
      ),
    );
  }

  Future<ApiResult<dynamic>> logout() async {
    try {
      final response = await _authApiServices.logout(
        currentUserType.name.firstLetterToUpperCase,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
