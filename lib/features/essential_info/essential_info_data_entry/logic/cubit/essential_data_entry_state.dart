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
  final String? selectedInsuranceType;
  final String? selectedDisabilityType;
 final String? selectedCity;
 final String? selectedArea;
 final String? selectedNeighborhood;

  // yes/no
  final bool? hasMedicalInsurance;
  final bool? hasChronicConditions;
  final bool? hasDisability;

  // validation + submission
  final bool isFormValidated;
  final RequestStatus submissionStatus;
  final String? message;

  const EssentialDataEntryState({
    required this.birthDate,
    required this.nationalIdIssueDate,
    required this.selectedGender,
    required this.selectedReligion,
    required this.selectedNationality,
    required this.selectedMaritalStatus,
    required this.selectedBloodType,
    required this.selectedEmploymentStatus,
    required this.selectedInsuranceType,
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
      selectedInsuranceType: null,
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
    String? selectedInsuranceType,
    String? selectedDisabilityType,
    bool? hasMedicalInsurance,
    bool? hasChronicConditions,
    bool? hasDisability,
    bool? isFormValidated,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return EssentialDataEntryState(
      birthDate: birthDate ?? this.birthDate,
      nationalIdIssueDate: nationalIdIssueDate ?? this.nationalIdIssueDate,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedReligion: selectedReligion ?? this.selectedReligion,
      selectedNationality: selectedNationality ?? this.selectedNationality,
      selectedMaritalStatus: selectedMaritalStatus ?? this.selectedMaritalStatus,
      selectedBloodType: selectedBloodType ?? this.selectedBloodType,
      selectedEmploymentStatus:
          selectedEmploymentStatus ?? this.selectedEmploymentStatus,
      selectedInsuranceType: selectedInsuranceType ?? this.selectedInsuranceType,
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
        selectedInsuranceType,
        selectedDisabilityType,
        hasMedicalInsurance,
        hasChronicConditions,
        hasDisability,
        isFormValidated,
        submissionStatus,
        message,
        selectedCity,
        selectedArea,
        selectedNeighborhood
      ];
}
