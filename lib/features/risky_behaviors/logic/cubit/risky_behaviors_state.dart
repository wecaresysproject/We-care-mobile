import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';

@immutable
class RiskyBehaviorsState extends Equatable {
  final RequestStatus status;
  final RequestStatus getBehaviorsStatus;
  final bool isFormValidated;
  final String? selectedSection;
  final String? selectedType;
  final String? selectedOption;
  final List<RiskyBehaviorPeriod> periods;
  final List<RiskyBehaviorDetailsModel> allBehaviors;
  final String message;
  final bool isEditMode;
  final String updatedDocId;
  final ModuleGuidanceDataModel? moduleGuidanceData;
  final bool attachToDrugInteractionModules;

  const RiskyBehaviorsState({
    this.status = RequestStatus.initial,
    this.getBehaviorsStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.selectedSection,
    this.selectedType,
    this.selectedOption,
    this.periods = const [],
    this.allBehaviors = const [],
    this.message = '',
    this.isEditMode = false,
    this.updatedDocId = '',
    this.moduleGuidanceData,
    this.attachToDrugInteractionModules = false,
  });

  const RiskyBehaviorsState.initialState() : this();

  RiskyBehaviorsState copyWith({
    RequestStatus? status,
    RequestStatus? getBehaviorsStatus,
    bool? isFormValidated,
    String? selectedSection,
    String? selectedType,
    String? selectedOption,
    List<RiskyBehaviorPeriod>? periods,
    List<RiskyBehaviorDetailsModel>? allBehaviors,
    String? message,
    bool? isEditMode,
    String? updatedDocId,
    ModuleGuidanceDataModel? moduleGuidanceData,
    bool? attachToDrugInteractionModules,
  }) {
    return RiskyBehaviorsState(
      status: status ?? this.status,
      getBehaviorsStatus: getBehaviorsStatus ?? this.getBehaviorsStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      selectedSection: selectedSection ?? this.selectedSection,
      selectedType: selectedType ?? this.selectedType,
      selectedOption: selectedOption ?? this.selectedOption,
      periods: periods ?? this.periods,
      allBehaviors: allBehaviors ?? this.allBehaviors,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
      updatedDocId: updatedDocId ?? this.updatedDocId,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
      attachToDrugInteractionModules:
          attachToDrugInteractionModules ?? this.attachToDrugInteractionModules,
    );
  }

  @override
  List<Object?> get props => [
        status,
        getBehaviorsStatus,
        isFormValidated,
        selectedSection,
        selectedType,
        selectedOption,
        periods,
        allBehaviors,
        message,
        isEditMode,
        updatedDocId,
        moduleGuidanceData,
        attachToDrugInteractionModules,
      ];
}
