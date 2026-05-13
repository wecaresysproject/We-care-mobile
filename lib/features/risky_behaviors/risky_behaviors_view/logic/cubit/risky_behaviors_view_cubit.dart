import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/risky_behaviors/data/repos/risk_behaviors_data_view_repo.dart';

import 'risky_behaviors_view_state.dart';

class RiskyBehaviorsViewCubit extends Cubit<RiskyBehaviorsViewState> {
  final AppSharedRepo _appSharedRepo;
  final RiskBehaviorsDataViewRepo _riskBehaviorsDataViewRepo;
  RiskyBehaviorsViewCubit(this._appSharedRepo, this._riskBehaviorsDataViewRepo)
      : super(const RiskyBehaviorsViewState.initialState()) {
    emitModuleGuidance();
    emitBehaviors();
  }

  Future<void> emitModuleGuidance() async {
    final result = await _appSharedRepo.getModuleGuidance(
      WeCareMedicalModules.riskyBehaviorsView.name,
    );
    result.when(
      success: (data) {
        emit(
          state.copyWith(
            moduleGuidanceData: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            moduleGuidanceData: null,
          ),
        );
      },
    );
  }

  Future<void> emitBehaviors() async {
    emit(state.copyWith(getBehaviorsStatus: RequestStatus.loading));

    final result = await _riskBehaviorsDataViewRepo.getUserRiskBehaviorsData();

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            getBehaviorsStatus: RequestStatus.success,
            allBehaviors: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            getBehaviorsStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }
}
