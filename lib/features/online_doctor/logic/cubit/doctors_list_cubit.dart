import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_summary_model.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  DoctorsListCubit(this._onlineDoctorRepo) : super(const DoctorsListState());

  final OnlineDoctorRepo _onlineDoctorRepo;

  /// بيجيب أطباء التخصص — [specialty] هو الـ `identifierName` بتاع التخصص
  /// (مثال: `internalMedicine`)، مش الاسم العربى المعروض.
  Future<void> getDoctorsBySpecialty(String specialty) async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.loading,
        specialty: specialty,
      ),
    );

    final result = await _onlineDoctorRepo.getDoctorsBySpecialty(
      specialty: specialty,
    );

    result.when(
      success: (doctors) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            doctors: doctors,
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

  Future<void> retry() => getDoctorsBySpecialty(state.specialty);
}
