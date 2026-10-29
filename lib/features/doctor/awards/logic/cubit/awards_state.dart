part of 'awards_cubit.dart';

class AwardsState extends Equatable {
  const AwardsState({
    required this.countriesNames,
    required this.entries,
    required this.submissionStatus,
    required this.message,
    required this.loadStatus,
    required this.isEditMode,
    required this.hasChanges,
  });

  factory AwardsState.initial() => AwardsState(
        countriesNames: const [],
        entries: [AwardFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
        loadStatus: RequestStatus.initial,
        isEditMode: false,
        hasChanges: true,
      );

  final List<String> countriesNames;
  final List<AwardFormEntry> entries;

  final RequestStatus submissionStatus;
  final String? message;

  /// Status of loading the saved awards. The form shows only on success.
  final RequestStatus loadStatus;

  /// True when the doctor already saved awards before, so the form opened
  /// pre-filled and the button reads "حفظ التعديلات".
  final bool isEditMode;

  /// Whether the form differs from the saved data. Always true outside
  /// [isEditMode].
  final bool hasChanges;

  AwardsState copyWith({
    List<String>? countriesNames,
    List<AwardFormEntry>? entries,
    RequestStatus? submissionStatus,
    String? message,
    RequestStatus? loadStatus,
    bool? isEditMode,
    bool? hasChanges,
  }) {
    return AwardsState(
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
