import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';

@immutable
class RiskyBehaviorsDataEntryState extends Equatable {
  final RequestStatus status;
  final RequestStatus sectionsStatus;
  final RequestStatus typesStatus;
  final RequestStatus optionsStatus;
  final bool isFormValidated;
  final String? selectedSection;
  final String? selectedType;
  final List<String> sections;
  final List<String> types;
  final List<String> options;
  final List<BehaviorRecord> records;
  final String message;
  final bool isEditMode;
  final String updatedDocId;
  final bool attachToDrugInteractionModules;
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const RiskyBehaviorsDataEntryState({
    this.status = RequestStatus.initial,
    this.sectionsStatus = RequestStatus.initial,
    this.typesStatus = RequestStatus.initial,
    this.optionsStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.selectedSection,
    this.selectedType,
    this.sections = const [],
    this.types = const [],
    this.options = const [],
    this.records = const [],
    this.message = '',
    this.isEditMode = false,
    this.updatedDocId = '',
    this.attachToDrugInteractionModules = false,
    this.moduleGuidanceData,
  });

  const RiskyBehaviorsDataEntryState.initialState() : this();

  RiskyBehaviorsDataEntryState copyWith({
    RequestStatus? status,
    RequestStatus? sectionsStatus,
    RequestStatus? typesStatus,
    RequestStatus? optionsStatus,
    bool? isFormValidated,
    String? selectedSection,
    String? selectedType,
    List<String>? sections,
    List<String>? types,
    List<String>? options,
    List<BehaviorRecord>? records,
    String? message,
    bool? isEditMode,
    String? updatedDocId,
    bool? attachToDrugInteractionModules,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return RiskyBehaviorsDataEntryState(
      status: status ?? this.status,
      sectionsStatus: sectionsStatus ?? this.sectionsStatus,
      typesStatus: typesStatus ?? this.typesStatus,
      optionsStatus: optionsStatus ?? this.optionsStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      selectedSection: selectedSection ?? this.selectedSection,
      selectedType: selectedType ?? this.selectedType,
      sections: sections ?? this.sections,
      types: types ?? this.types,
      options: options ?? this.options,
      records: records ?? this.records,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
      updatedDocId: updatedDocId ?? this.updatedDocId,
      attachToDrugInteractionModules:
          attachToDrugInteractionModules ?? this.attachToDrugInteractionModules,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
  }

  @override
  List<Object?> get props => [
        status,
        sectionsStatus,
        typesStatus,
        optionsStatus,
        isFormValidated,
        selectedSection,
        selectedType,
        sections,
        types,
        options,
        records,
        message,
        isEditMode,
        updatedDocId,
        attachToDrugInteractionModules,
        moduleGuidanceData,
      ];
}
