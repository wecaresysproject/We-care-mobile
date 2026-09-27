import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/monthly_examination_target/data/models/monthly_examination_target_model.dart';
import 'package:we_care/features/doctor/monthly_examination_target/data/repos/monthly_examination_target_repo.dart';

part 'monthly_examination_target_state.dart';

class MonthlyExaminationTargetCubit extends Cubit<MonthlyExaminationTargetState>
    with SafeEmitMixin<MonthlyExaminationTargetState> {
  MonthlyExaminationTargetCubit(this._monthlyExaminationTargetRepo)
      : super(MonthlyExaminationTargetState.initial());

  final MonthlyExaminationTargetRepo _monthlyExaminationTargetRepo;

  /// Reasonable monthly target counts offered in the goal picker.
  static const goalCountOptions = [10, 20, 30, 50, 100, 150, 200];

  Future<void> loadMonthlyTargetData() async {
    safeEmit(state.copyWith(loadingStatus: RequestStatus.loading));

    final response =
        await _monthlyExaminationTargetRepo.getMonthlyTargetHistory();
    response.when(
      success: (history) => safeEmit(
        state.copyWith(
          loadingStatus: RequestStatus.success,
          history: history,
          selectedGoalCount: history.isNotEmpty ? history.first.goalCount : 0,
          achievedCount: history.isNotEmpty ? history.first.achievedCount : 0,
        ),
      ),
      failure: (error) => safeEmit(
        state.copyWith(
          loadingStatus: RequestStatus.failure,
          message: error.errors.first,
        ),
      ),
    );
  }

  void updateSelectedGoalCount(int goalCount) =>
      safeEmit(state.copyWith(selectedGoalCount: goalCount));

  Future<void> saveSettings() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final response = await _monthlyExaminationTargetRepo
        .submitMonthlyTarget(state.selectedGoalCount);
    response.when(
      success: (message) => safeEmit(
        state.copyWith(
          message: message,
          submissionStatus: RequestStatus.success,
        ),
      ),
      failure: (error) => safeEmit(
        state.copyWith(
          message: error.errors.first,
          submissionStatus: RequestStatus.failure,
        ),
      ),
    );
  }
}
