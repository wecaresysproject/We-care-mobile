part of 'awards_cubit.dart';

class AwardsState extends Equatable {
  const AwardsState({
    required this.countriesNames,
    required this.entries,
    required this.submissionStatus,
    required this.message,
  });

  factory AwardsState.initial() => AwardsState(
        countriesNames: const [],
        entries: [AwardFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  final List<String> countriesNames;
  final List<AwardFormEntry> entries;

  final RequestStatus submissionStatus;
  final String? message;

  AwardsState copyWith({
    List<String>? countriesNames,
    List<AwardFormEntry>? entries,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return AwardsState(
      countriesNames: countriesNames ?? this.countriesNames,
      entries: entries ?? this.entries,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        countriesNames,
        entries,
        submissionStatus,
        message,
      ];
}
