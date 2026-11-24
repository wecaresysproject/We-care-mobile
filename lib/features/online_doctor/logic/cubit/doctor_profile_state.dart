part of 'doctor_profile_cubit.dart';

class DoctorProfileState extends Equatable {
  final RequestStatus requestStatus;
  final String doctorId;
  final DoctorModel? doctor;
  final String errorMessage;

  /// حالة الطبيب فى المفضلة — بتبدأ من البروفايل وبتتحدّث من رد الـ API.
  final bool isFavorite;

  /// حالة طلب الإضافة/الإزالة من المفضلة — منفصلة عن تحميل البروفايل.
  final RequestStatus favoriteStatus;

  /// رسالة نجاح/فشل آخر طلب مفضلة — بتتعرض كـ toast.
  final String favoriteMessage;

  /// تعليقات المرضى المعروضة — بتبدأ بأحدث 3 من البروفايل، وكل "المزيد"
  /// بيضيف عليها صفحة.
  final List<DoctorProfileCommentModel> comments;

  /// إجمالى التعليقات — بيحدد ظهور "المزيد".
  final int commentsTotalCount;

  /// حالة طلب "المزيد" — منفصلة عن تحميل البروفايل.
  final RequestStatus moreCommentsStatus;

  bool get hasMoreComments => comments.length < commentsTotalCount;

  const DoctorProfileState({
    this.requestStatus = RequestStatus.initial,
    this.doctorId = '',
    this.doctor,
    this.errorMessage = '',
    this.isFavorite = false,
    this.favoriteStatus = RequestStatus.initial,
    this.favoriteMessage = '',
    this.comments = const [],
    this.commentsTotalCount = 0,
    this.moreCommentsStatus = RequestStatus.initial,
  });

  DoctorProfileState copyWith({
    RequestStatus? requestStatus,
    String? doctorId,
    DoctorModel? doctor,
    String? errorMessage,
    bool? isFavorite,
    RequestStatus? favoriteStatus,
    String? favoriteMessage,
    List<DoctorProfileCommentModel>? comments,
    int? commentsTotalCount,
    RequestStatus? moreCommentsStatus,
  }) {
    return DoctorProfileState(
      requestStatus: requestStatus ?? this.requestStatus,
      doctorId: doctorId ?? this.doctorId,
      doctor: doctor ?? this.doctor,
      errorMessage: errorMessage ?? this.errorMessage,
      isFavorite: isFavorite ?? this.isFavorite,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
      favoriteMessage: favoriteMessage ?? this.favoriteMessage,
      comments: comments ?? this.comments,
      commentsTotalCount: commentsTotalCount ?? this.commentsTotalCount,
      moreCommentsStatus: moreCommentsStatus ?? this.moreCommentsStatus,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        doctorId,
        doctor,
        errorMessage,
        isFavorite,
        favoriteStatus,
        favoriteMessage,
        comments,
        commentsTotalCount,
        moreCommentsStatus,
      ];
}
