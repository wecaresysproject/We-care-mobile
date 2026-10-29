part of 'membership_cubit.dart';

class MembershipState extends Equatable {
  const MembershipState({
    required this.countriesNames,
    required this.entries,
    required this.submissionStatus,
    required this.message,
    required this.loadStatus,
    required this.isEditMode,
    required this.hasChanges,
  });

  factory MembershipState.initial() => MembershipState(
        countriesNames: const [],
        entries: [MembershipFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
        loadStatus: RequestStatus.initial,
        isEditMode: false,
        hasChanges: true,
      );

  final List<String> countriesNames;
  final List<MembershipFormEntry> entries;

  final RequestStatus submissionStatus;
  final String? message;

  /// Status of loading the saved memberships. The form shows only on success.
  final RequestStatus loadStatus;

  /// True when the doctor already saved memberships before, so the form opened
  /// pre-filled and the button reads "حفظ التعديلات".
  final bool isEditMode;

  /// Whether the form differs from the saved data. Always true outside
  /// [isEditMode].
  final bool hasChanges;

  MembershipState copyWith({
    List<String>? countriesNames,
    List<MembershipFormEntry>? entries,
    RequestStatus? submissionStatus,
    String? message,
    RequestStatus? loadStatus,
    bool? isEditMode,
    bool? hasChanges,
  }) {
    return MembershipState(
      countriesNames: countriesNames ?? this.countriesNames,
      entries: entries ?? this.entries,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
      loadStatus: loadStatus ?? this.loadStatus,
      isEditMode: isEditMode ?? this.isEditMode,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  @override
  List<Object?> get props => [
        countriesNames,
        entries,
        submissionStatus,
        message,
        loadStatus,
        isEditMode,
        hasChanges,
      ];
}
