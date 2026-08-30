part of 'doctors_list_cubit.dart';

class DoctorsListState extends Equatable {
  final RequestStatus requestStatus;
  final String specialty;
  final List<DoctorSummaryModel> doctors;
  final String errorMessage;

  const DoctorsListState({
    this.requestStatus = RequestStatus.initial,
    this.specialty = '',
    this.doctors = const [],
    this.errorMessage = '',
  });

  DoctorsListState copyWith({
    RequestStatus? requestStatus,
    String? specialty,
    List<DoctorSummaryModel>? doctors,
    String? errorMessage,
  }) {
    return DoctorsListState(
      requestStatus: requestStatus ?? this.requestStatus,
      specialty: specialty ?? this.specialty,
      doctors: doctors ?? this.doctors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [requestStatus, specialty, doctors, errorMessage];
}
