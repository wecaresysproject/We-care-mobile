import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/features/online_doctor/data/models/video_meeting_model.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';
import 'package:we_care/features/online_doctor/video_call_logger.dart';

part 'examination_call_state.dart';

class ExaminationCallCubit extends Cubit<ExaminationCallState> {
  ExaminationCallCubit(this._onlineDoctorRepo)
      : super(const ExaminationCallState());

  final OnlineDoctorRepo _onlineDoctorRepo;

  /// الفاصل بين محاولات جلب الاجتماع طول ما الطبيب لسه مبدأش.
  static const Duration _pollInterval = Duration(seconds: 5);

  Timer? _pollTimer;
  String _bookingId = '';

  /// المريض بيجيب الاجتماع بس — الإنشاء والبدء عند الطبيب.
  Future<void> loadMeeting(String bookingId) async {
    _bookingId = bookingId;
    _pollTimer?.cancel();
    VideoCallLogger.info('loadMeeting → bookingId=$bookingId');
    emit(state.copyWith(status: ExaminationCallStatus.loading));
    await _fetchMeeting();
  }

  Future<void> _fetchMeeting() async {
    final result = await _onlineDoctorRepo.getVideoMeeting(
      appointmentId: _bookingId,
    );
    if (isClosed) return;

    result.when(
      success: (meeting) {
        if (meeting == null) {
          VideoCallLogger.info('GET meeting → 404 (الطبيب لسه منشأش الاجتماع)');
          _waitForDoctor();
          return;
        }
        VideoCallLogger.info(
          'GET meeting → status=${meeting.status.name} '
          'room=${meeting.room} url=${meeting.meetingUrl}',
        );
        switch (meeting.status) {
          case VideoMeetingStatus.created:
            _waitForDoctor();
          case VideoMeetingStatus.ended:
            emit(
              state.copyWith(
                status: ExaminationCallStatus.ended,
                meeting: meeting,
              ),
            );
          case VideoMeetingStatus.started:
            if (!meeting.isJoinable) {
              VideoCallLogger.error(
                'meetingUrl غير صالح: "${meeting.meetingUrl}"',
              );
              emit(
                state.copyWith(
                  status: ExaminationCallStatus.failure,
                  errorMessage: "رابط الاجتماع غير صالح",
                ),
              );
              return;
            }
            emit(
              state.copyWith(
                status: ExaminationCallStatus.ready,
                meeting: meeting,
              ),
            );
        }
      },
      failure: (error) {
        final message = error.errors.first;
        VideoCallLogger.error('GET meeting failed → $message');
        // فشل مؤقت أثناء الانتظار ميقفلش الشاشة — بنكمل محاولات.
        if (state.status == ExaminationCallStatus.waitingForDoctor) {
          _scheduleNextPoll();
          return;
        }
        emit(
          state.copyWith(
            status: ExaminationCallStatus.failure,
            errorMessage: message,
          ),
        );
      },
    );
  }

  void _waitForDoctor() {
    if (state.status != ExaminationCallStatus.waitingForDoctor) {
      emit(state.copyWith(status: ExaminationCallStatus.waitingForDoctor));
    }
    _scheduleNextPoll();
  }

  void _scheduleNextPoll() {
    _pollTimer?.cancel();
    _pollTimer = Timer(_pollInterval, _fetchMeeting);
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    VideoCallLogger.info('cubit closed');
    return super.close();
  }
}
