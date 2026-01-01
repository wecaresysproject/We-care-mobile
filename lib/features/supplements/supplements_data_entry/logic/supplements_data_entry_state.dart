import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/supplements/data/models/supplement_entry_model.dart';

class SupplementsDataEntryState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<String> availableVitamins;
  final RequestStatus vitaminsStatus;
  final List<SupplementEntry> entries;

  const SupplementsDataEntryState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.availableVitamins = const [],
    this.vitaminsStatus = RequestStatus.initial,
    this.entries = const [],
  });

  factory SupplementsDataEntryState.initial() {
    return SupplementsDataEntryState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      availableVitamins: const [],
      vitaminsStatus: RequestStatus.initial,
      entries: List.generate(6, (_) => const SupplementEntry()),
    );
  }

  SupplementsDataEntryState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<String>? availableVitamins,
    RequestStatus? vitaminsStatus,
    List<SupplementEntry>? entries,
  }) {
    return SupplementsDataEntryState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      availableVitamins: availableVitamins ?? this.availableVitamins,
      vitaminsStatus: vitaminsStatus ?? this.vitaminsStatus,
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        availableVitamins,
        vitaminsStatus,
        entries,
      ];
}
