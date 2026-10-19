part of 'doctor_video_call_cubit.dart';

enum DoctorVideoCallStatus {
  loading,

  /// The meeting is created and started — the screen opens the room.
  ready,
  ended,
  failure,
}

@immutable
class DoctorVideoCallState extends Equatable {
  final DoctorVideoCallStatus status;

  /// Null until the meeting is created.
  final VideoMeetingModel? meeting;
  final String message;

  const DoctorVideoCallState({
    required this.status,
    this.meeting,
    this.message = '',
  });

  factory DoctorVideoCallState.initial() =>
      const DoctorVideoCallState(status: DoctorVideoCallStatus.loading);

  DoctorVideoCallState copyWith({
    DoctorVideoCallStatus? status,
    VideoMeetingModel? meeting,
    String? message,
  }) {
    return DoctorVideoCallState(
      status: status ?? this.status,
      meeting: meeting ?? this.meeting,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, meeting, message];
}
