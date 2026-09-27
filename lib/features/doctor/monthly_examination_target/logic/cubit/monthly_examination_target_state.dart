part of 'monthly_examination_target_cubit.dart';

class MonthlyExaminationTargetState extends Equatable {
  const MonthlyExaminationTargetState({
    required this.loadingStatus,
    required this.history,
    required this.selectedGoalCount,
    required this.achievedCount,
    required this.submissionStatus,
    required this.message,
  });

  factory MonthlyExaminationTargetState.initial() =>
      const MonthlyExaminationTargetState(
        loadingStatus: RequestStatus.initial,
        history: [],
        selectedGoalCount: 0,
        achievedCount: 0,
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  /// Status of the initial history + current-goal fetch.
  final RequestStatus loadingStatus;

  /// Monthly-target history, most recent month first. The first entry is the
  /// current month's record.
  final List<MonthlyExaminationTargetModel> history;

  /// The goal count currently selected in the picker (defaults to the
  /// current month's goal once loaded).
  final int selectedGoalCount;

  /// The current month's achieved examination count.
  final int achievedCount;

  /// Status of the "Save Settings" submission.
  final RequestStatus submissionStatus;
  final String? message;

  /// Current-month completion percentage against [selectedGoalCount],
  /// clamped to [0, 100].
  int get completionPercentage {
    if (selectedGoalCount <= 0) return 0;
    return ((achievedCount / selectedGoalCount) * 100).round().clamp(0, 100);
  }

  MonthlyExaminationTargetState copyWith({
    RequestStatus? loadingStatus,
    List<MonthlyExaminationTargetModel>? history,
    int? selectedGoalCount,
    int? achievedCount,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return MonthlyExaminationTargetState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      history: history ?? this.history,
      selectedGoalCount: selectedGoalCount ?? this.selectedGoalCount,
      achievedCount: achievedCount ?? this.achievedCount,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        loadingStatus,
        history,
        selectedGoalCount,
        achievedCount,
        submissionStatus,
        message,
      ];
}
