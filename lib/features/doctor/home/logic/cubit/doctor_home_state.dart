part of 'doctor_home_cubit.dart';

/// Each home section keeps its own status and data, so one slow or failing
/// endpoint never blocks the rest of the screen.
@immutable
class DoctorHomeState extends Equatable {
  final RequestStatus profileStatus;
  final DoctorProfileSummaryModel? profile;

  final RequestStatus bookingsStatsStatus;
  final DoctorBookingsStatsModel? bookingsStats;

  final RequestStatus monthlyExaminationsStatus;
  final DoctorMonthlyExaminationsModel? monthlyExaminations;

  final RequestStatus performanceStatsStatus;
  final DoctorPerformanceStatsModel? performanceStats;

  final RequestStatus adsStatus;
  final List<String>? ads;

  final RequestStatus latestCommentsStatus;
  final DoctorLatestCommentsModel? latestComments;

  final RequestStatus ratingsSummaryStatus;
  final DoctorRatingsSummaryModel? ratingsSummary;

  final String message;
  final RequestStatus logoutStatus;

  const DoctorHomeState({
    this.profileStatus = RequestStatus.initial,
    this.profile,
    this.bookingsStatsStatus = RequestStatus.initial,
    this.bookingsStats,
    this.monthlyExaminationsStatus = RequestStatus.initial,
    this.monthlyExaminations,
    this.performanceStatsStatus = RequestStatus.initial,
    this.performanceStats,
    this.adsStatus = RequestStatus.initial,
    this.ads,
    this.latestCommentsStatus = RequestStatus.initial,
    this.latestComments,
    this.ratingsSummaryStatus = RequestStatus.initial,
    this.ratingsSummary,
    this.message = '',
    this.logoutStatus = RequestStatus.initial,
  });

  factory DoctorHomeState.initial() => const DoctorHomeState();

  DoctorHomeState copyWith({
    RequestStatus? profileStatus,
    DoctorProfileSummaryModel? profile,
    RequestStatus? bookingsStatsStatus,
    DoctorBookingsStatsModel? bookingsStats,
    RequestStatus? monthlyExaminationsStatus,
    DoctorMonthlyExaminationsModel? monthlyExaminations,
    RequestStatus? performanceStatsStatus,
    DoctorPerformanceStatsModel? performanceStats,
    RequestStatus? adsStatus,
    List<String>? ads,
    RequestStatus? latestCommentsStatus,
    DoctorLatestCommentsModel? latestComments,
    RequestStatus? ratingsSummaryStatus,
    DoctorRatingsSummaryModel? ratingsSummary,
    String? message,
    RequestStatus? logoutStatus,
  }) {
    return DoctorHomeState(
      profileStatus: profileStatus ?? this.profileStatus,
      profile: profile ?? this.profile,
      bookingsStatsStatus: bookingsStatsStatus ?? this.bookingsStatsStatus,
      bookingsStats: bookingsStats ?? this.bookingsStats,
      monthlyExaminationsStatus:
          monthlyExaminationsStatus ?? this.monthlyExaminationsStatus,
      monthlyExaminations: monthlyExaminations ?? this.monthlyExaminations,
      performanceStatsStatus:
          performanceStatsStatus ?? this.performanceStatsStatus,
      performanceStats: performanceStats ?? this.performanceStats,
      adsStatus: adsStatus ?? this.adsStatus,
      ads: ads ?? this.ads,
      latestCommentsStatus: latestCommentsStatus ?? this.latestCommentsStatus,
      latestComments: latestComments ?? this.latestComments,
      ratingsSummaryStatus: ratingsSummaryStatus ?? this.ratingsSummaryStatus,
      ratingsSummary: ratingsSummary ?? this.ratingsSummary,
      message: message ?? this.message,
      logoutStatus: logoutStatus ?? this.logoutStatus,
    );
  }

  @override
  List<Object?> get props => [
        profileStatus,
        profile,
        bookingsStatsStatus,
        bookingsStats,
        monthlyExaminationsStatus,
        monthlyExaminations,
        performanceStatsStatus,
        performanceStats,
        adsStatus,
        ads,
        latestCommentsStatus,
        latestComments,
        ratingsSummaryStatus,
        ratingsSummary,
        message,
        logoutStatus,
      ];
}
