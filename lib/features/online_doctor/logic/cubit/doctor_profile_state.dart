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

  const DoctorProfileState({
    this.requestStatus = RequestStatus.initial,
    this.doctorId = '',
    this.doctor,
    this.errorMessage = '',
    this.isFavorite = false,
    this.favoriteStatus = RequestStatus.initial,
    this.favoriteMessage = '',
  });

  DoctorProfileState copyWith({
    RequestStatus? requestStatus,
    String? doctorId,
    DoctorModel? doctor,
    String? errorMessage,
    bool? isFavorite,
    RequestStatus? favoriteStatus,
    String? favoriteMessage,
  }) {
    return DoctorProfileState(
      requestStatus: requestStatus ?? this.requestStatus,
      doctorId: doctorId ?? this.doctorId,
      doctor: doctor ?? this.doctor,
      errorMessage: errorMessage ?? this.errorMessage,
      isFavorite: isFavorite ?? this.isFavorite,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
      favoriteMessage: favoriteMessage ?? this.favoriteMessage,
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
      ];
}
