import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';

import 'risky_behaviors_state.dart';

class RiskyBehaviorsCubit extends Cubit<RiskyBehaviorsState> {
  final AppSharedRepo _appSharedRepo;

  RiskyBehaviorsCubit(this._appSharedRepo)
      : super(const RiskyBehaviorsState.initialState()) {
    emitModuleGuidance();
    emitBehaviors();
  }

  Future<void> emitModuleGuidance() async {
    final result = await _appSharedRepo.getModuleGuidance(
      WeCareMedicalModules.riskyBehaviors.name,
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
        option: "من 5 إلى 20 يوميًا",
        periods: [
          RiskyBehaviorPeriod(fromDate: "2024-01-01", toDate: "2024-06-01"),
          RiskyBehaviorPeriod(fromDate: "2024-08-01"),
        ],
      ),
      const RiskyBehaviorDetailsModel(
        id: "2",
        section: "التدخين",
        type: "Vape",
        option: "من حين لآخر",
        periods: [
          RiskyBehaviorPeriod(fromDate: "2023-10-01", toDate: "2023-12-31"),
        ],
      ),
      const RiskyBehaviorDetailsModel(
        id: "3",
        section: "التدخين",
        type: "الشيشة",
        option: "أسبوعي",
        periods: [
          RiskyBehaviorPeriod(fromDate: "2024-01-01", toDate: "2024-06-01"),
          RiskyBehaviorPeriod(fromDate: "2024-08-01"),
        ],
      ),
      const RiskyBehaviorDetailsModel(
        id: "4",
        section: "الكحول",
        type: "كحول عام",
        option: "نادر",
        periods: [
          RiskyBehaviorPeriod(fromDate: "2022-01-01", toDate: "2022-06-01"),
        ],
      ),
      const RiskyBehaviorDetailsModel(
        id: "5",
        section: "المخدرات",
        type: "الحشيش",
        option: "نادر",
        periods: [
          RiskyBehaviorPeriod(fromDate: "2022-01-01", toDate: "2022-06-01"),
          RiskyBehaviorPeriod(fromDate: "2022-01-01", toDate: "2022-06-01"),
          RiskyBehaviorPeriod(fromDate: "2022-01-01", toDate: "2022-06-01"),
        ],
      ),
    ];

    emit(state.copyWith(
      getBehaviorsStatus: RequestStatus.success,
      allBehaviors: dummyBehaviors,
    ));
  }

  // Static Dummy Data
  final List<String> sections = ["التدخين", "الكحول", "المخدرات"];

  final Map<String, List<String>> typesBySection = {
    "التدخين": ["سجائر", "شيشة", "IQOS", "Vape"],
    "الكحول": ["كحول عام"],
    "المخدرات": ["الحشيش", "المنبهات", "الهيروين", "الكوكايين", "مخدرات أخرى"],
  };

  final Map<String, List<String>> optionsBySection = {
    "التدخين": ["أقل من 5 يوميًا", "من 5 إلى 20 يوميًا", "أكثر من 20 يوميًا"],
    "الكحول": ["نادر", "أسبوعي", "يومي"],
    "المخدرات": ["نادر", "أسبوعي", "يومي"],
  };

  void updateSection(String section) {
    emit(state.copyWith(
      selectedSection: section,
      selectedType: null, // Reset type when section changes
      selectedOption: null, // Reset option when section changes
    ));
    validateForm();
  }

  void updateType(String type) {
    emit(state.copyWith(selectedType: type));
    validateForm();
  }

  void updateOption(String option) {
    emit(state.copyWith(selectedOption: option));
    validateForm();
  }

  void addPeriod(RiskyBehaviorPeriod period) {
    if (state.periods.length < 3) {
      final updatedPeriods = List<RiskyBehaviorPeriod>.from(state.periods)
        ..add(period);
      emit(state.copyWith(periods: updatedPeriods));
      validateForm();
    }
  }

  void removePeriod(int index) {
    final updatedPeriods = List<RiskyBehaviorPeriod>.from(state.periods)
      ..removeAt(index);
    emit(state.copyWith(periods: updatedPeriods));
    validateForm();
  }

  void validateForm() {
    final isValid = state.selectedSection != null &&
        state.selectedType != null &&
        state.selectedOption != null &&
        state.periods.isNotEmpty;

    emit(state.copyWith(isFormValidated: isValid));
  }

  void toggleAttachToDrugInteractionModules(bool? value) {
    emit(state.copyWith(attachToDrugInteractionModules: value ?? false));
  }

  Future<void> submit() async {
    if (!state.isFormValidated) return;

    emit(state.copyWith(status: RequestStatus.loading));

    // Simulate API call with the new field
    final requestModel = RiskyBehaviorDetailsModel(
      section: state.selectedSection!,
      type: state.selectedType!,
      option: state.selectedOption!,
      periods: state.periods,
      attachToDrugInteractionModules: state.attachToDrugInteractionModules,
    );

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      status: RequestStatus.success,
      message: "تم حفظ البيانات بنجاح",
    ));
  }

  void loadExistingData(RiskyBehaviorDetailsModel existingData) {
    emit(state.copyWith(
      selectedSection: existingData.section,
      selectedType: existingData.type,
      selectedOption: existingData.option,
      periods: existingData.periods,
      attachToDrugInteractionModules:
          existingData.attachToDrugInteractionModules ?? false,
      isEditMode: true,
      updatedDocId: existingData.id ?? '',
    ));
    validateForm();
  }

  List<String> getAvailableTypes() {
    if (state.selectedSection == null) return [];
    return typesBySection[state.selectedSection] ?? [];
  }

  List<String> getAvailableOptions() {
    if (state.selectedSection == null) return [];
    return optionsBySection[state.selectedSection] ?? [];
  }
}
