import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

part 'doctor_profile_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  DoctorProfileCubit(this._onlineDoctorRepo)
      : super(const DoctorProfileState());

  final OnlineDoctorRepo _onlineDoctorRepo;

  Future<void> getDoctorProfile(String doctorId) async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.loading,
        doctorId: doctorId,
      ),
    );

    final result = await _onlineDoctorRepo.getDoctorProfile(
      doctorId: doctorId,
    );

    result.when(
      success: (doctor) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            doctor: doctor,
            isFavorite: doctor.isFavorite,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            errorMessage: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> retry() => getDoctorProfile(state.doctorId);

  /// بيقلب حالة المفضلة على السيرفر — القلب بيتحدّث من رد الـ API مش محليًا،
  /// عشان الشاشة تفضل مطابقة لحالة السيرفر حتى لو الطلب فشل.
  Future<void> toggleFavorite() async {
    final doctor = state.doctor;
    if (doctor == null || state.favoriteStatus == RequestStatus.loading) {
      return;
    }

    final targetIsFavorite = !state.isFavorite;
    emit(state.copyWith(favoriteStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.setDoctorFavorite(
      doctorId: doctor.id,
      isFavorite: targetIsFavorite,
    );

    result.when(
      success: (isFavorite) {
        emit(
          state.copyWith(
            favoriteStatus: RequestStatus.success,
            isFavorite: isFavorite,
            favoriteMessage: isFavorite
                ? "تمت الإضافة إلى المفضلة"
                : "تمت الإزالة من المفضلة",
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            favoriteStatus: RequestStatus.failure,
            favoriteMessage: error.errors.first,
          ),
        );
      },
    );
  }
}
