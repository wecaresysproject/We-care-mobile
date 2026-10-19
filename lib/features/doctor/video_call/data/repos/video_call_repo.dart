import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/online_doctor/data/models/video_meeting_model.dart';

class VideoCallRepo {
  final DoctorServices _doctorServices;

  VideoCallRepo(this._doctorServices);

  /// Creates the meeting of [appointmentId] — or returns the existing one,
  /// so calling it again for the same appointment is safe.
  Future<ApiResult<VideoMeetingModel>> createMeeting(
    String appointmentId,
  ) async {
    try {
      final response = await _doctorServices.createVideoMeeting(
        {"appointmentId": appointmentId},
      );
      return ApiResult.success(_meetingFromResponse(response));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Marks the meeting as started — the patient can only join after this.
  Future<ApiResult<VideoMeetingModel>> startMeeting(
    String appointmentId,
  ) async {
    try {
      final response = await _doctorServices.startVideoMeeting(appointmentId);
      return ApiResult.success(_meetingFromResponse(response));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Marks the meeting as ended. It does not close the Jitsi room itself.
  Future<ApiResult<VideoMeetingModel>> endMeeting(String appointmentId) async {
    try {
      final response = await _doctorServices.endVideoMeeting(appointmentId);
      return ApiResult.success(_meetingFromResponse(response));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  VideoMeetingModel _meetingFromResponse(dynamic response) =>
      VideoMeetingModel.fromJson(response['data'] as Map<String, dynamic>);
}
