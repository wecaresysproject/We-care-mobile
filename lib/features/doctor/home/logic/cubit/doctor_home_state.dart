part of 'doctor_home_cubit.dart';

@immutable
class DoctorHomeState extends Equatable {
  final RequestStatus status;
  final DoctorHomeModel? doctorHome;
  final String message;
  final RequestStatus logoutStatus;

  const DoctorHomeState({
    required this.status,
    this.doctorHome,
    this.message = '',
    this.logoutStatus = RequestStatus.initial,
  });

  factory DoctorHomeState.initial() =>
      const DoctorHomeState(status: RequestStatus.initial);

  DoctorHomeState copyWith({
    RequestStatus? status,
    DoctorHomeModel? doctorHome,
    String? message,
    RequestStatus? logoutStatus,
  }) {
    return DoctorHomeState(
      status: status ?? this.status,
      doctorHome: doctorHome ?? this.doctorHome,
      message: message ?? this.message,
      logoutStatus: logoutStatus ?? this.logoutStatus,
    );
  }

  @override
  List<Object?> get props => [status, doctorHome, message, logoutStatus];
}
