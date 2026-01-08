part of 'medication_compitability_cubit.dart';

@immutable
class MedicationCompitabilityState extends Equatable {
  final RequestStatus requestStatus;
  final String message; // error or success message

  const MedicationCompitabilityState({
    required this.requestStatus,
    required this.message,
  }) : super();

  const MedicationCompitabilityState.initialState()
      : this(
          requestStatus: RequestStatus.initial,
          message: '',
        );

  MedicationCompitabilityState copyWith({
    RequestStatus? requestStatus,
    String? message,
  }) {
    return MedicationCompitabilityState(
      requestStatus: requestStatus ?? this.requestStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        message,
      ];
}
