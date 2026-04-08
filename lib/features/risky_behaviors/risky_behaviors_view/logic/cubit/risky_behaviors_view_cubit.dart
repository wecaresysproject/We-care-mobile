import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';

import 'risky_behaviors_view_state.dart';

class RiskyBehaviorsViewCubit extends Cubit<RiskyBehaviorsViewState> {
  final AppSharedRepo _appSharedRepo;

  RiskyBehaviorsViewCubit(this._appSharedRepo)
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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final dummyBehaviors = [
      const RiskyBehaviorDetailsModel(
        id: "1",
        section: "التدخين",
        type: "سجائر",
        records: [
          BehaviorRecord(
            option: "من 5 إلى 20 يوميًا",
            period: RiskyBehaviorPeriod(
                fromDate: "2024-01-01", toDate: "2024-06-01"),
          ),
          BehaviorRecord(
            option: "أكثر من 20 يوميًا",
            period: RiskyBehaviorPeriod(fromDate: "2024-08-01"),
          ),
        ],
        attachToDrugInteractionModules: true,
      ),
      const RiskyBehaviorDetailsModel(
        id: "2",
        section: "التدخين",
        type: "Vape",
        records: [
          BehaviorRecord(
            option: "أقل من 5 يوميًا",
            period: RiskyBehaviorPeriod(
                fromDate: "2023-10-01", toDate: "2023-12-31"),
          ),
        ],
      ),
      const RiskyBehaviorDetailsModel(
        id: "3",
        section: "الكحول",
        type: "كحول عام",
        records: [
          BehaviorRecord(
            option: "نادر",
            period: RiskyBehaviorPeriod(
                fromDate: "2022-01-01", toDate: "2023-01-01"),
          ),
          BehaviorRecord(
            option: "أسبوعي",
            period: RiskyBehaviorPeriod(fromDate: "2023-05-01"),
          ),
        ],
      ),
      const RiskyBehaviorDetailsModel(
        id: "4",
        section: "المخدرات",
        type: "الحشيش",
        records: [
          BehaviorRecord(
            option: "يومي",
            period: RiskyBehaviorPeriod(fromDate: "2024-09-01"),
          ),
        ],
        attachToDrugInteractionModules: true,
      ),
    ];

    emit(state.copyWith(
      getBehaviorsStatus: RequestStatus.success,
      allBehaviors: dummyBehaviors,
    ));
  }
}
