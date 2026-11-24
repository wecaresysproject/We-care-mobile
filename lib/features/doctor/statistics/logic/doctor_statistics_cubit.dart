import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/statistics/data/models/doctor_statistics_model.dart';
import 'package:we_care/features/doctor/statistics/data/repos/doctor_statistics_repo.dart';

/// "إحصائيات": the doctor picks a month and a year, then "عرض" loads them.
/// Opens on the current month.
class DoctorStatisticsCubit extends Cubit<DoctorStatisticsState>
    with SafeEmitMixin {
  DoctorStatisticsCubit(this._repo)
      : super(DoctorStatisticsState.initial(DateTime.now()));

  final DoctorStatisticsRepo _repo;

  void selectMonth(int month) => safeEmit(state.copyWith(selectedMonth: month));

  void selectYear(int year) => safeEmit(state.copyWith(selectedYear: year));

  /// "عرض" — loads the picked month.
  Future<void> load() async {
    final month = state.selectedMonth;
    final year = state.selectedYear;
    safeEmit(state.copyWith(status: RequestStatus.loading));
    final result = await _repo.getStatistics(month: month, year: year);
    // The doctor picked another month while this one was loading.
    if (month != state.selectedMonth || year != state.selectedYear) return;
    result.when(
      success: (statistics) => safeEmit(
        state.copyWith(
          status: RequestStatus.success,
          statistics: () => statistics,
        ),
      ),
      failure: (error) => safeEmit(
        state.copyWith(
          status: RequestStatus.failure,
          message: () => error.errors.firstOrNull,
        ),
      ),
    );
  }
}

@immutable
class DoctorStatisticsState extends Equatable {
  const DoctorStatisticsState({
    required this.selectedMonth,
    required this.selectedYear,
    this.status = RequestStatus.initial,
    this.statistics,
    this.message,
  });

  factory DoctorStatisticsState.initial(DateTime now) =>
      DoctorStatisticsState(selectedMonth: now.month, selectedYear: now.year);

  /// 1–12.
  final int selectedMonth;
  final int selectedYear;
  final RequestStatus status;

  /// The last loaded month — stays on screen while another one loads.
  final DoctorStatisticsModel? statistics;
  final String? message;

  DoctorStatisticsState copyWith({
    int? selectedMonth,
    int? selectedYear,
    RequestStatus? status,
    DoctorStatisticsModel? Function()? statistics,
    String? Function()? message,
  }) =>
      DoctorStatisticsState(
        selectedMonth: selectedMonth ?? this.selectedMonth,
        selectedYear: selectedYear ?? this.selectedYear,
        status: status ?? this.status,
        statistics: statistics != null ? statistics() : this.statistics,
        message: message != null ? message() : this.message,
      );

  @override
  List<Object?> get props =>
      [selectedMonth, selectedYear, status, statistics, message];
}
