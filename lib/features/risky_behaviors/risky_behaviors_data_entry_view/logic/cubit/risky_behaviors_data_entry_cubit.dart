import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';
import 'package:we_care/features/risky_behaviors/data/repos/risk_behaviors_data_entry_repo.dart';

import 'risky_behaviors_data_entry_state.dart';

class RiskyBehaviorsDataEntryCubit extends Cubit<RiskyBehaviorsDataEntryState> {
  final AppSharedRepo _appSharedRepo;
  final RiskBehaviorDataEntryRepo _riskBehaviorDataEntryRepo;

  RiskyBehaviorsDataEntryCubit(
      this._appSharedRepo, this._riskBehaviorDataEntryRepo)
      : super(const RiskyBehaviorsDataEntryState.initialState()) {
    getInitalRequests();
  }

  Future<void> getInitalRequests() async {
    await Future.wait([
      getSections(),
      emitModuleGuidance(),
    ]);
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

  Future<void> getSections() async {
    safeEmit(state.copyWith(sectionsStatus: RequestStatus.loading));
    final result = await _riskBehaviorDataEntryRepo.getSections();
    result.when(
      success: (data) {
        safeEmit(state.copyWith(
          sectionsStatus: RequestStatus.success,
          sections: data,
        ));
      },
      failure: (error) {
        safeEmit(state.copyWith(sectionsStatus: RequestStatus.failure));
      },
    );
  }

  Future<void> getTypes(String section) async {
    safeEmit(state.copyWith(typesStatus: RequestStatus.loading));
    final result = await _riskBehaviorDataEntryRepo.getTypes(section);
    result.when(
      success: (data) {
        safeEmit(state.copyWith(
          typesStatus: RequestStatus.success,
          types: data,
        ));
      },
      failure: (error) {
        safeEmit(state.copyWith(typesStatus: RequestStatus.failure));
      },
    );
  }

  Future<void> getOptions(String section, String type) async {
    safeEmit(state.copyWith(optionsStatus: RequestStatus.loading));
    final result = await _riskBehaviorDataEntryRepo.getOptions(section, type);
    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            optionsStatus: RequestStatus.success,
            options: data,
          ),
        );
      },
      failure: (error) {
        safeEmit(state.copyWith(optionsStatus: RequestStatus.failure));
      },
    );
  }

  void updateSection(String section) {
    safeEmit(
      state.copyWith(
        selectedSection: section,
      ),
    );
    getTypes(section);
    validateForm();
  }

  void safeEmit(RiskyBehaviorsDataEntryState cubitState) {
    if (!isClosed) emit(cubitState);
  }

  void updateType(String type) {
    safeEmit(state.copyWith(
      selectedType: type,
      options: [],
    ));
    if (state.selectedSection != null) {
      getOptions(state.selectedSection!, type);
    }
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
    getTypes(existingData.section);
    getOptions(existingData.section, existingData.type);
    validateForm();
  }

  List<String> getAvailableTypes() {
    return state.types;
  }

  List<String> getAvailableOptions() {
    return state.options;
  }
}
