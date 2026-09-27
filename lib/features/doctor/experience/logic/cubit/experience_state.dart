part of 'experience_cubit.dart';

class ExperienceState extends Equatable {
  const ExperienceState({
    required this.countriesNames,
    required this.entries,
    required this.submissionStatus,
    required this.message,
  });

  factory ExperienceState.initial() => ExperienceState(
        countriesNames: const [],
        entries: [ExperienceFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  final List<String> countriesNames;
  final List<ExperienceFormEntry> entries;

  final RequestStatus submissionStatus;
  final String? message;

  ExperienceState copyWith({
    List<String>? countriesNames,
    List<ExperienceFormEntry>? entries,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return ExperienceState(
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
