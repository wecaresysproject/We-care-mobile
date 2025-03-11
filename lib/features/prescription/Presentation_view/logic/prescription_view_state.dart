import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

class PrescriptionViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<int> yearsFilter;
  final List<String> doctorNameFilter;
  final List<String> specificationsFilter;

  const PrescriptionViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.doctorNameFilter = const ['الكل'],
    this.specificationsFilter = const ['الكل'],
  });

  factory PrescriptionViewState.initial() {
    return PrescriptionViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      yearsFilter: const [],
      doctorNameFilter: const ['الكل'],
      specificationsFilter: const ['الكل'],
    );
  }

  PrescriptionViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? yearsFilter,
    List<String>? doctorNameFilter,
    List<String>? specificationsFilter,
  }) {
    return PrescriptionViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      doctorNameFilter: doctorNameFilter ?? this.doctorNameFilter,
      specificationsFilter: specificationsFilter ?? this.specificationsFilter,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        yearsFilter,
        doctorNameFilter,
        specificationsFilter
      ];
}
