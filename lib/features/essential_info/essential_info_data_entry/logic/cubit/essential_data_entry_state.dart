// essential_data_entry_state.dart
part of 'essential_data_entry_cubit.dart';

class EssentialDataEntryState extends Equatable {
  final String? birthDate;
  final String? nationalIdIssueDate;

  // selected options
  final String? selectedGender;
  final String? selectedReligion;
  final String? selectedNationality;
  final String? selectedMaritalStatus;
  final String? selectedBloodType;
  final String? selectedEmploymentStatus;
  final String? selectedDisabilityType;
  final String? selectedCity;
  final String? selectedArea;
  final String? selectedNeighborhood;
  final String? weeklyWorkingHours;
  final bool? isMarried;

  // yes/no
  final bool? hasMedicalInsurance;
  final bool? hasChronicConditions;
  final bool? hasDisability;
// Medical insurance section
  final String? insuranceCompany;
  final String? insuranceEndDate;
  final String? insuranceAdditionalConditions;
  final String? insuranceCardImagePath;

  // validation + submission
  final bool isFormValidated;
  final RequestStatus submissionStatus;
  final String? message;
  final bool isEditMode;

  const EssentialDataEntryState({
    required this.birthDate,
    required this.nationalIdIssueDate,
    required this.selectedGender,
    required this.selectedReligion,
    required this.selectedNationality,
    required this.selectedMaritalStatus,
    required this.selectedBloodType,
    required this.selectedEmploymentStatus,
    required this.selectedDisabilityType,
    required this.hasMedicalInsurance,
    required this.hasChronicConditions,
    required this.hasDisability,
    required this.isFormValidated,
    required this.submissionStatus,
    required this.message,
    required this.selectedCity,
    required this.selectedArea,
    required this.selectedNeighborhood,
    required this.insuranceCompany,
    required this.insuranceEndDate,
    required this.insuranceAdditionalConditions,
    required this.insuranceCardImagePath,
    required this.weeklyWorkingHours,
    this.isMarried,
    this.isEditMode = false,
  });

  factory EssentialDataEntryState.initial() {
    return const EssentialDataEntryState(
      birthDate: null,
      nationalIdIssueDate: null,
      selectedGender: null,
      selectedReligion: null,
      selectedNationality: null,
      selectedMaritalStatus: null,
      selectedBloodType: null,
      selectedEmploymentStatus: null,
      selectedDisabilityType: null,
      hasMedicalInsurance: null,
      hasChronicConditions: null,
      hasDisability: null,
      isFormValidated: false,
      submissionStatus: RequestStatus.initial,
      message: null,
      selectedCity: null,
      selectedArea: null,
      selectedNeighborhood: null,
      insuranceCompany: null,
      insuranceEndDate: null,
      insuranceAdditionalConditions: null,
      insuranceCardImagePath: null,
      weeklyWorkingHours: null,
      isMarried: null,
      isEditMode: false,
    );
  }

  EssentialDataEntryState copyWith({
    String? birthDate,
    String? nationalIdIssueDate,
    String? selectedGender,
    String? selectedReligion,
    String? selectedNationality,
    String? selectedCity,
    String? selectedArea,
    String? selectedNeighborhood,
    String? selectedMaritalStatus,
    String? selectedBloodType,
    String? selectedEmploymentStatus,
    String? selectedDisabilityType,
    bool? hasMedicalInsurance,
    bool? hasChronicConditions,
    bool? hasDisability,
    bool? isFormValidated,
    RequestStatus? submissionStatus,
    String? message,
    String? insuranceCompany,
    String? insuranceEndDate,
    String? insuranceAdditionalConditions,
    String? insuranceCardImagePath,
    String? weeklyWorkingHours,
    bool? isMarried,
    bool isEditMode = false,
  }) {
    return EssentialDataEntryState(
      birthDate: birthDate ?? this.birthDate,
      nationalIdIssueDate: nationalIdIssueDate ?? this.nationalIdIssueDate,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedReligion: selectedReligion ?? this.selectedReligion,
      selectedNationality: selectedNationality ?? this.selectedNationality,
      selectedMaritalStatus:
          selectedMaritalStatus ?? this.selectedMaritalStatus,
      selectedBloodType: selectedBloodType ?? this.selectedBloodType,
      selectedEmploymentStatus:
          selectedEmploymentStatus ?? this.selectedEmploymentStatus,
      selectedDisabilityType:
          selectedDisabilityType ?? this.selectedDisabilityType,
      hasMedicalInsurance: hasMedicalInsurance ?? this.hasMedicalInsurance,
      hasChronicConditions: hasChronicConditions ?? this.hasChronicConditions,
      hasDisability: hasDisability ?? this.hasDisability,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedArea: selectedArea ?? this.selectedArea,
      selectedNeighborhood: selectedNeighborhood ?? this.selectedNeighborhood,
      insuranceCompany: insuranceCompany ?? this.insuranceCompany,
      insuranceEndDate: insuranceEndDate ?? this.insuranceEndDate,
      insuranceAdditionalConditions:
          insuranceAdditionalConditions ?? this.insuranceAdditionalConditions,
      insuranceCardImagePath:
          insuranceCardImagePath ?? this.insuranceCardImagePath,
      weeklyWorkingHours: weeklyWorkingHours ?? this.weeklyWorkingHours,
      isMarried: isMarried ?? this.isMarried,
      isEditMode: isEditMode,
    );
  }

  @override
  List<Object?> get props => [
        birthDate,
        nationalIdIssueDate,
        selectedGender,
        selectedReligion,
        selectedNationality,
        selectedMaritalStatus,
        selectedBloodType,
        selectedEmploymentStatus,
        selectedDisabilityType,
        hasMedicalInsurance,
        hasChronicConditions,
        hasDisability,
        isFormValidated,
        submissionStatus,
        message,
        selectedCity,
        selectedArea,
        selectedNeighborhood,
        insuranceCompany,
        insuranceEndDate,
        insuranceAdditionalConditions,
        insuranceCardImagePath,
        weeklyWorkingHours,
        isMarried,
        isEditMode,
      ];
}
