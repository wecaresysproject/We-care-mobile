import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/video_call/data/repos/video_call_repo.dart';
import 'package:we_care/features/online_doctor/data/models/video_meeting_model.dart';
import 'package:we_care/features/online_doctor/video_call_logger.dart';

part 'doctor_video_call_state.dart';

class DoctorVideoCallCubit extends Cubit<DoctorVideoCallState>
    with SafeEmitMixin<DoctorVideoCallState> {
  DoctorVideoCallCubit(this._videoCallRepo)
      : super(DoctorVideoCallState.initial());

  final VideoCallRepo _videoCallRepo;

  String _appointmentId = '';

  /// Creates the appointment's meeting (or gets the existing one) and marks
  /// it started, so the patient side is let in.
  Future<void> openMeeting(String appointmentId) async {
    _appointmentId = appointmentId;
    VideoCallLogger.info('doctor openMeeting → appointmentId=$appointmentId');
    safeEmit(state.copyWith(status: DoctorVideoCallStatus.loading));

    final created = await _videoCallRepo.createMeeting(appointmentId);
    final createdMeeting = created.when(
      success: (meeting) {
        VideoCallLogger.info(
          'create meeting → status=${meeting.status.name} '
          'room=${meeting.room} url=${meeting.meetingUrl}',
        );
        return meeting;
      },
      failure: (error) {
        _emitFailure('create meeting', error.errors.first);
        return null;
      },
    );
    if (createdMeeting == null) return;

    if (createdMeeting.status == VideoMeetingStatus.ended) {
      safeEmit(
        state.copyWith(
          status: DoctorVideoCallStatus.ended,
          meeting: createdMeeting,
        ),
      );
      return;
    }

    final started = await _videoCallRepo.startMeeting(appointmentId);
    started.when(
      success: (meeting) {
        VideoCallLogger.info(
          'start meeting → status=${meeting.status.name} '
          'startedAt=${meeting.startedAt}',
        );
        if (!meeting.isJoinable) {
          _emitFailure(
            'start meeting',
            'رابط الاجتماع غير صالح',
            details: 'meetingUrl="${meeting.meetingUrl}"',
          );
          return;
        }
        safeEmit(
          state.copyWith(
            status: DoctorVideoCallStatus.ready,
            meeting: meeting,
          ),
        );
      },
      failure: (error) => _emitFailure('start meeting', error.errors.first),
    );
  }

  /// Marks the meeting as ended. Returns null once the backend confirms it,
  /// otherwise the error message for the caller to show.
  Future<String?> endMeeting() async {
    VideoCallLogger.info('doctor endMeeting → appointmentId=$_appointmentId');
    final result = await _videoCallRepo.endMeeting(_appointmentId);
    return result.when(
      success: (meeting) {
        VideoCallLogger.info(
          'end meeting → status=${meeting.status.name} '
          'endedAt=${meeting.endedAt}',
        );
        return null;
      },
      failure: (error) {
        VideoCallLogger.error('end meeting failed → ${error.errors.first}');
        return error.errors.first;
      },
    );
  }

  void _emitFailure(String step, String message, {String details = ''}) {
    VideoCallLogger.error('$step failed → $message $details');
    safeEmit(
      state.copyWith(status: DoctorVideoCallStatus.failure, message: message),
    );
  }
}
