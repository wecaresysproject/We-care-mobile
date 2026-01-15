part of 'physical_activaty_data_entry_cubit.dart';

@immutable
class PhysicalActivatyDataEntryState extends Equatable {
  final RequestStatus submitPhysicalActivityDataStatus;

  final bool isFormValidated;

  final bool isEditMode;
  final String message; // error or success message
  final int followUpNutrationViewCurrentTabIndex;
  final String selectedPlanDate;
  final String? genderType;
  final String? selectedMuscleDesity;

  final List<Day> days;

  final bool monthlyActivationStatus;
  final bool weeklyActivationStatus;
  final bool isAnyPlanActivated;

  const PhysicalActivatyDataEntryState({
    this.submitPhysicalActivityDataStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.message = '',
    this.isEditMode = false,
    this.followUpNutrationViewCurrentTabIndex = 0,
    this.selectedPlanDate = '',
    this.genderType = 'ذكر',
    this.selectedMuscleDesity = 'شخص متوسط الكتلة العضلية (عادي)',
    this.monthlyActivationStatus = false,
    this.weeklyActivationStatus = false,
    this.days = const [],
    this.isAnyPlanActivated = false,
  }) : super();

  const PhysicalActivatyDataEntryState.initialState()
      : this(
          submitPhysicalActivityDataStatus: RequestStatus.initial,
          isFormValidated: false,
          message: '',
          isEditMode: false,
          followUpNutrationViewCurrentTabIndex: 0,
          selectedPlanDate: '',
          genderType: 'ذكر',
          selectedMuscleDesity: 'شخص متوسط الكتلة العضلية (عادي)',
          monthlyActivationStatus: false,
          weeklyActivationStatus: false,
          days: const [],
          isAnyPlanActivated: false,
        );

  PhysicalActivatyDataEntryState copyWith({
    RequestStatus? submitPhysicalActivityDataStatus,
    bool? isFormValidated,
    String? message,
    bool? isEditMode,
    int? followUpNutrationViewCurrentTabIndex,
    String? selectedPlanDate,
    String? genderType,
    String? selectedMuscleDesity,
    bool? monthlyActivationStatus,
    bool? weeklyActivationStatus,
    List<Day>? days,
    bool? isAnyPlanActivated,
  }) {
    return PhysicalActivatyDataEntryState(
      submitPhysicalActivityDataStatus: submitPhysicalActivityDataStatus ??
          this.submitPhysicalActivityDataStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
      followUpNutrationViewCurrentTabIndex:
          followUpNutrationViewCurrentTabIndex ??
              this.followUpNutrationViewCurrentTabIndex,
      selectedPlanDate: selectedPlanDate ?? this.selectedPlanDate,
      genderType: genderType ?? this.genderType,
      selectedMuscleDesity: selectedMuscleDesity ?? this.selectedMuscleDesity,
      monthlyActivationStatus:
          monthlyActivationStatus ?? this.monthlyActivationStatus,
      weeklyActivationStatus:
          weeklyActivationStatus ?? this.weeklyActivationStatus,
      days: days ?? this.days,
      isAnyPlanActivated: isAnyPlanActivated ?? this.isAnyPlanActivated,
    );
  }

  @override
  List<Object?> get props => [
        submitPhysicalActivityDataStatus,
        isFormValidated,
        isEditMode,
        message,
        followUpNutrationViewCurrentTabIndex,
        selectedPlanDate,
        genderType,
        selectedMuscleDesity,
        monthlyActivationStatus,
        weeklyActivationStatus,
        days,
        isAnyPlanActivated,
      ];
}
