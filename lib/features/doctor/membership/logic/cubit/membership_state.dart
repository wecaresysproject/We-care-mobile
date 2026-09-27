part of 'membership_cubit.dart';

class MembershipState extends Equatable {
  const MembershipState({
    required this.countriesNames,
    required this.entries,
    required this.submissionStatus,
    required this.message,
  });

  factory MembershipState.initial() => MembershipState(
        countriesNames: const [],
        entries: [MembershipFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  final List<String> countriesNames;
  final List<MembershipFormEntry> entries;

  final RequestStatus submissionStatus;
  final String? message;

  MembershipState copyWith({
    List<String>? countriesNames,
    List<MembershipFormEntry>? entries,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return MembershipState(
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
