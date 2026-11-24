import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_bookings_stats_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_latest_comments_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_monthly_examinations_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_performance_stats_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_profile_summary_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_ratings_summary_model.dart';
import 'package:we_care/features/doctor/home/data/repos/doctor_home_repo.dart';

part 'doctor_home_state.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeState>
    with SafeEmitMixin<DoctorHomeState> {
  DoctorHomeCubit(this._homeRepo) : super(DoctorHomeState.initial());

  final DoctorHomeRepo _homeRepo;

  /// Shows the cached header at once, then loads every section in parallel.
  Future<void> loadHome() async {
    final cachedProfile = await _homeRepo.getCachedProfileSummary();
    if (cachedProfile != null) {
      safeEmit(state.copyWith(
        profile: cachedProfile,
        profileStatus: RequestStatus.success,
      ));
    }
    await refreshHome();
  }

  /// Reloads every section in parallel — also backs pull-to-refresh.
  Future<void> refreshHome() => Future.wait([
        getProfileSummary(),
        getBookingsStats(),
        getMonthlyExaminations(),
        getPerformanceStats(),
        getAds(),
        getLatestComments(),
        getRatingsSummary(),
      ]);

  Future<void> getProfileSummary() async {
    safeEmit(state.copyWith(profileStatus: RequestStatus.loading));
    final response = await _homeRepo.getProfileSummary();
    response.when(
      success: (profile) => safeEmit(state.copyWith(
        profile: profile,
        profileStatus: RequestStatus.success,
      )),
      failure: (error) => safeEmit(state.copyWith(
        profileStatus: RequestStatus.failure,
        message: _firstError(error.errors),
      )),
    );
  }

  Future<void> getBookingsStats() async {
    safeEmit(state.copyWith(bookingsStatsStatus: RequestStatus.loading));
    final response = await _homeRepo.getBookingsStats();
    response.when(
      success: (stats) => safeEmit(state.copyWith(
        bookingsStats: stats,
        bookingsStatsStatus: RequestStatus.success,
      )),
      failure: (error) => safeEmit(state.copyWith(
        bookingsStatsStatus: RequestStatus.failure,
        message: _firstError(error.errors),
      )),
    );
  }

  Future<void> getMonthlyExaminations() async {
    safeEmit(state.copyWith(monthlyExaminationsStatus: RequestStatus.loading));
    final response = await _homeRepo.getMonthlyExaminations();
    response.when(
      success: (examinations) => safeEmit(state.copyWith(
        monthlyExaminations: examinations,
        monthlyExaminationsStatus: RequestStatus.success,
      )),
      failure: (error) => safeEmit(state.copyWith(
        monthlyExaminationsStatus: RequestStatus.failure,
        message: _firstError(error.errors),
      )),
    );
  }

  Future<void> getPerformanceStats() async {
    safeEmit(state.copyWith(performanceStatsStatus: RequestStatus.loading));
    final response = await _homeRepo.getPerformanceStats();
    response.when(
      success: (stats) => safeEmit(state.copyWith(
        performanceStats: stats,
        performanceStatsStatus: RequestStatus.success,
      )),
      failure: (error) => safeEmit(state.copyWith(
        performanceStatsStatus: RequestStatus.failure,
        message: _firstError(error.errors),
      )),
    );
  }

  Future<void> getAds() async {
    safeEmit(state.copyWith(adsStatus: RequestStatus.loading));
    final response = await _homeRepo.getAds();
    response.when(
      success: (ads) => safeEmit(state.copyWith(
        ads: ads,
        adsStatus: RequestStatus.success,
      )),
      failure: (error) => safeEmit(state.copyWith(
        adsStatus: RequestStatus.failure,
        message: _firstError(error.errors),
      )),
    );
  }

  Future<void> getLatestComments() async {
    safeEmit(state.copyWith(latestCommentsStatus: RequestStatus.loading));
    final response = await _homeRepo.getLatestComments();
    response.when(
      success: (comments) => safeEmit(state.copyWith(
        latestComments: comments,
        latestCommentsStatus: RequestStatus.success,
      )),
      failure: (error) => safeEmit(state.copyWith(
        latestCommentsStatus: RequestStatus.failure,
        message: _firstError(error.errors),
      )),
    );
  }

  Future<void> getRatingsSummary() async {
    safeEmit(state.copyWith(ratingsSummaryStatus: RequestStatus.loading));
    final response = await _homeRepo.getRatingsSummary();
    response.when(
      success: (summary) => safeEmit(state.copyWith(
        ratingsSummary: summary,
        ratingsSummaryStatus: RequestStatus.success,
      )),
      failure: (error) => safeEmit(state.copyWith(
        ratingsSummaryStatus: RequestStatus.failure,
        message: _firstError(error.errors),
      )),
    );
  }

  Future<void> logout() async {
    safeEmit(state.copyWith(logoutStatus: RequestStatus.loading));
    final response = await _homeRepo.logout();
    response.when(
      success: (_) async {
        await clearUserSession();
        safeEmit(state.copyWith(logoutStatus: RequestStatus.success));
      },
      failure: (error) => safeEmit(
        state.copyWith(
          logoutStatus: RequestStatus.failure,
          message:
              error.errors.isNotEmpty ? error.errors.first : 'Failed to logout',
        ),
      ),
    );
  }

  String _firstError(List<String> errors) =>
      errors.isNotEmpty ? errors.first : '';
}
