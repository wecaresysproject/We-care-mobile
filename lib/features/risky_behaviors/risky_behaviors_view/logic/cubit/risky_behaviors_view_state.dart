import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';

@immutable
class RiskyBehaviorsViewState extends Equatable {
  final RequestStatus getBehaviorsStatus;
  final List<RiskyBehaviorDetailsModel> allBehaviors;
  final String message;
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const RiskyBehaviorsViewState({
    this.getBehaviorsStatus = RequestStatus.initial,
    this.allBehaviors = const [],
    this.message = '',
    this.moduleGuidanceData,
  });

  const RiskyBehaviorsViewState.initialState() : this();

  RiskyBehaviorsViewState copyWith({
    RequestStatus? getBehaviorsStatus,
    List<RiskyBehaviorDetailsModel>? allBehaviors,
    String? message,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return RiskyBehaviorsViewState(
      getBehaviorsStatus: getBehaviorsStatus ?? this.getBehaviorsStatus,
      allBehaviors: allBehaviors ?? this.allBehaviors,
      message: message ?? this.message,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
  }

  @override
  List<Object?> get props => [
        getBehaviorsStatus,
        allBehaviors,
        message,
        moduleGuidanceData,
      ];
}
