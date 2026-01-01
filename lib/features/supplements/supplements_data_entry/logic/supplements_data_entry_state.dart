import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/nutration/data/models/get_all_created_plans_model.dart';
import 'package:we_care/features/supplements/data/models/supplement_entry_model.dart';

class SupplementsDataEntryState extends Equatable {
  final RequestStatus requestStatus;
  final String message;
  final List<String> availableVitamins;
  final RequestStatus vitaminsStatus;
  final List<SupplementEntry> entries;
  final bool monthlyActivationStatus;
  final bool weeklyActivationStatus;
  final List<Day> days;
  final int supplementFollowUpCurrentTabIndex;
  final String selectedPlanDate;
  final bool isAnyPlanActivated;

  const SupplementsDataEntryState({
    this.message = '',
    this.requestStatus = RequestStatus.initial,
    this.availableVitamins = const [],
    this.vitaminsStatus = RequestStatus.initial,
    this.entries = const [],
    this.monthlyActivationStatus = false,
    this.weeklyActivationStatus = false,
    this.days = const [],
    this.isAnyPlanActivated = false,
    this.supplementFollowUpCurrentTabIndex = 0,
    this.selectedPlanDate = '',
  });

  factory SupplementsDataEntryState.initial() {
    return SupplementsDataEntryState(
      message: '',
      requestStatus: RequestStatus.initial,
      availableVitamins: const [],
      vitaminsStatus: RequestStatus.initial,
      entries: List.generate(
        6,
        (_) => const SupplementEntry(),
      ),
      monthlyActivationStatus: false,
      weeklyActivationStatus: false,
      days: const [],
      isAnyPlanActivated: false,
      supplementFollowUpCurrentTabIndex: 0,
      selectedPlanDate: '',
    );
  }

  SupplementsDataEntryState copyWith({
    String? message,
    RequestStatus? requestStatus,
    List<String>? availableVitamins,
    RequestStatus? vitaminsStatus,
    List<SupplementEntry>? entries,
    bool? monthlyActivationStatus,
    bool? weeklyActivationStatus,
    List<Day>? days,
    bool? isAnyPlanActivated,
    int? supplementFollowUpCurrentTabIndex,
    String? selectedPlanDate,
  }) {
    return SupplementsDataEntryState(
      message: message ?? this.message,
      requestStatus: requestStatus ?? this.requestStatus,
      availableVitamins: availableVitamins ?? this.availableVitamins,
      vitaminsStatus: vitaminsStatus ?? this.vitaminsStatus,
      entries: entries ?? this.entries,
      monthlyActivationStatus:
          monthlyActivationStatus ?? this.monthlyActivationStatus,
      weeklyActivationStatus:
          weeklyActivationStatus ?? this.weeklyActivationStatus,
      days: days ?? this.days,
      isAnyPlanActivated: isAnyPlanActivated ?? this.isAnyPlanActivated,
      supplementFollowUpCurrentTabIndex: supplementFollowUpCurrentTabIndex ??
          this.supplementFollowUpCurrentTabIndex,
      selectedPlanDate: selectedPlanDate ?? this.selectedPlanDate,
    );
  }

  @override
  List<Object?> get props => [
        message,
        requestStatus,
        availableVitamins,
        vitaminsStatus,
        entries,
        monthlyActivationStatus,
        weeklyActivationStatus,
        days,
        isAnyPlanActivated,
        supplementFollowUpCurrentTabIndex,
        selectedPlanDate,
      ];
}
