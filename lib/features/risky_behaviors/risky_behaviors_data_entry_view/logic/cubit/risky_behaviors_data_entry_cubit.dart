import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';

import 'risky_behaviors_data_entry_state.dart';

class RiskyBehaviorsDataEntryCubit extends Cubit<RiskyBehaviorsDataEntryState> {
  final AppSharedRepo _appSharedRepo;

  RiskyBehaviorsDataEntryCubit(this._appSharedRepo)
      : super(const RiskyBehaviorsDataEntryState.initialState()) {
    emitModuleGuidance();
  }

  Future<void> emitModuleGuidance() async {
    final result = await _appSharedRepo.getModuleGuidance(
      WeCareMedicalModules.riskyBehaviorsDataEntry.name,
    );
    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            moduleGuidanceData: data,
          ),
        );
      },
      failure: (failure) {
        safeEmit(
          state.copyWith(
            moduleGuidanceData: null,
          ),
        );
      },
    );
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
    safeEmit(
      state.copyWith(
        selectedSection: section,
        selectedType: null,
        records: [],
      ),
    );
    validateForm();
  }

  void safeEmit(RiskyBehaviorsDataEntryState cubitState) {
    if (!isClosed) emit(cubitState);
  }

  void updateType(String type) {
    safeEmit(state.copyWith(selectedType: type));
    validateForm();
  }

  void addRecord(BehaviorRecord record) {
    if (state.records.length < 3) {
      final updatedRecords = List<BehaviorRecord>.from(state.records)
        ..add(record);
      safeEmit(state.copyWith(records: updatedRecords));
      validateForm();
    }
  }

  void removeRecord(int index) {
    final updatedRecords = List<BehaviorRecord>.from(state.records)
      ..removeAt(index);
    safeEmit(state.copyWith(records: updatedRecords));
    validateForm();
  }

  void validateForm() {
    final isValid = state.selectedSection != null &&
        state.selectedType != null &&
        state.records.isNotEmpty;

    safeEmit(state.copyWith(isFormValidated: isValid));
  }

  void toggleAttachToDrugInteractionModules(bool? value) {
    safeEmit(state.copyWith(attachToDrugInteractionModules: value ?? false));
  }

  Future<void> submit() async {
    if (!state.isFormValidated) return;

    safeEmit(state.copyWith(status: RequestStatus.loading));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    safeEmit(state.copyWith(
      status: RequestStatus.success,
      message: "تم حفظ البيانات بنجاح",
    ));
  }

  void loadExistingData(RiskyBehaviorDetailsModel existingData) {
    safeEmit(
      state.copyWith(
        selectedSection: existingData.section,
        selectedType: existingData.type,
        records: existingData.records,
        attachToDrugInteractionModules:
            existingData.attachToDrugInteractionModules ?? false,
        isEditMode: true,
        updatedDocId: existingData.id ?? '',
      ),
    );
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
