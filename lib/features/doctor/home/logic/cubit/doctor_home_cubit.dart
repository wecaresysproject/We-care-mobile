import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_home_model.dart';
import 'package:we_care/features/doctor/home/data/repos/doctor_home_repo.dart';

part 'doctor_home_state.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeState>
    with SafeEmitMixin<DoctorHomeState> {
  DoctorHomeCubit(this._homeRepo) : super(DoctorHomeState.initial());

  final DoctorHomeRepo _homeRepo;

  Future<void> getDoctorHome() async {
    safeEmit(state.copyWith(status: RequestStatus.loading));
    final response = await _homeRepo.getDoctorHome();
    response.when(
      success: (doctorHome) => safeEmit(
        state.copyWith(status: RequestStatus.success, doctorHome: doctorHome),
      ),
      failure: (error) => safeEmit(
        state.copyWith(
          status: RequestStatus.failure,
          message: error.errors.first,
        ),
      ),
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
}
