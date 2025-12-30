import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

class SupplementsViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<String> availableDateRanges;

  const SupplementsViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.availableDateRanges = const [],
  });

  factory SupplementsViewState.initial() {
    return SupplementsViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      availableDateRanges: const [],
    );
  }

  SupplementsViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<String>? availableDateRanges,
  }) {
    return SupplementsViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      availableDateRanges: availableDateRanges ?? this.availableDateRanges,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        availableDateRanges,
      ];
}
