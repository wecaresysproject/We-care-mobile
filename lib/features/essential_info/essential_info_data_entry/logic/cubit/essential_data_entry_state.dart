// essential_data_entry_state.dart
part of 'essential_data_entry_cubit.dart';

class EssentialDataEntryState extends Equatable {
  final String? birthDate;
  final String? nationalIdIssueDate;
  final List<String> countriesNames;
  final List<String> citiesNames;
  final List<String> areasNames;
  final List<String> neighborhoodsNames;

  // selected options
  final String? selectedGender;
  final String? selectedReligion;
  final String? selectedNationality;
  final String? selectedMaritalStatus;
  final String? selectedBloodType;
  final String? selectedDisabilityType;
  final String? selectedCity;
  final String? weeklyWorkingHours;
  final String? disabilityLevel;
  final String? socialStatus;

  // yes/no
  final bool? hasMedicalInsurance;
  final bool? hasDisability;
// Medical insurance section
  final String? insuranceCompany;
  final String? insuranceEndDate;
  final String? insuranceAdditionalConditions;
  final String? insuranceCardImagePath;
  final String? userPersonalImage;

  // validation + submission
  final bool isFormValidated;
  final RequestStatus submissionStatus;
  final UploadImageRequestStatus? uploadImageRequestStatus;
  final String? profilePictureUploadedUrl;
  final String? insuranceCardPhotoUrl;
  final String? message;
  final bool isEditMode;
  final bool? isPictureSelected;

  const EssentialDataEntryState({
    required this.birthDate,
    required this.nationalIdIssueDate,
    required this.selectedGender,
    required this.selectedReligion,
    required this.selectedNationality,
    required this.selectedMaritalStatus,
    required this.selectedBloodType,
    required this.selectedDisabilityType,
    required this.hasMedicalInsurance,
    required this.hasDisability,
    required this.isFormValidated,
    required this.submissionStatus,
    required this.message,
    required this.selectedCity,
    required this.insuranceCompany,
    required this.insuranceEndDate,
    required this.insuranceAdditionalConditions,
    required this.insuranceCardImagePath,
    required this.weeklyWorkingHours,
    this.socialStatus,
    this.isEditMode = false,
    required this.countriesNames,
    required this.citiesNames,
    required this.areasNames,
    required this.neighborhoodsNames,
    this.userPersonalImage,
    this.disabilityLevel,
    this.uploadImageRequestStatus,
    this.profilePictureUploadedUrl,
    this.isPictureSelected,
    this.insuranceCardPhotoUrl,
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
      selectedDisabilityType: null,
      hasMedicalInsurance: null,
      hasDisability: null,
      isFormValidated: false,
      submissionStatus: RequestStatus.initial,
      message: null,
      selectedCity: null,
      insuranceCompany: null,
      insuranceEndDate: null,
      insuranceAdditionalConditions: null,
      insuranceCardImagePath: null,
      weeklyWorkingHours: null,
      socialStatus: null,
      isEditMode: false,
      countriesNames: [],
      citiesNames: [],
      areasNames: [],
      neighborhoodsNames: [],
      userPersonalImage: null,
      disabilityLevel: null,
      uploadImageRequestStatus: null,
      profilePictureUploadedUrl: null,
      isPictureSelected: null,
      insuranceCardPhotoUrl: null,
    );
  }

  EssentialDataEntryState copyWith({
    String? birthDate,
    String? nationalIdIssueDate,
    String? selectedGender,
    String? selectedReligion,
    String? selectedNationality,
    String? selectedCity,
    String? selectedMaritalStatus,
    String? selectedBloodType,
    String? selectedDisabilityType,
    bool? hasMedicalInsurance,
    bool? hasDisability,
    bool? isFormValidated,
    RequestStatus? submissionStatus,
    String? message,
    String? insuranceCompany,
    String? insuranceEndDate,
    String? insuranceAdditionalConditions,
    String? insuranceCardImagePath,
    String? weeklyWorkingHours,
    String? socialStatus,
    bool isEditMode = false,
    List<String>? countriesNames,
    List<String>? citiesNames,
    List<String>? areasNames,
    List<String>? neighborhoodsNames,
    String? userPersonalImage,
    String? disabilityLevel,
     UploadImageRequestStatus? uploadImageRequestStatus,
      String? pictureUploadedUrl,
    bool? isPictureSelected,
    String? insuranceCardPhotoUrl,
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
      selectedDisabilityType:
          selectedDisabilityType ?? this.selectedDisabilityType,
      hasMedicalInsurance: hasMedicalInsurance ?? this.hasMedicalInsurance,
      hasDisability: hasDisability ?? this.hasDisability,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
      selectedCity: selectedCity ?? this.selectedCity,
      insuranceCompany: insuranceCompany ?? this.insuranceCompany,
      insuranceEndDate: insuranceEndDate ?? this.insuranceEndDate,
      insuranceAdditionalConditions:
          insuranceAdditionalConditions ?? this.insuranceAdditionalConditions,
      insuranceCardImagePath:
          insuranceCardImagePath ?? this.insuranceCardImagePath,
      weeklyWorkingHours: weeklyWorkingHours ?? this.weeklyWorkingHours,
      socialStatus: socialStatus ?? this.socialStatus,
      isEditMode: isEditMode,
      countriesNames: countriesNames ?? this.countriesNames,
      citiesNames: citiesNames ?? this.citiesNames,
      areasNames: areasNames ?? this.areasNames,
      neighborhoodsNames: neighborhoodsNames ?? this.neighborhoodsNames,
      userPersonalImage: userPersonalImage ?? this.userPersonalImage,
      disabilityLevel: disabilityLevel ?? this.disabilityLevel,
      uploadImageRequestStatus:
          uploadImageRequestStatus ?? this.uploadImageRequestStatus,
      profilePictureUploadedUrl: pictureUploadedUrl ?? this.profilePictureUploadedUrl,
      isPictureSelected: isPictureSelected ?? this.isPictureSelected,
      insuranceCardPhotoUrl: insuranceCardPhotoUrl ?? this.insuranceCardPhotoUrl,
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
        selectedDisabilityType,
        hasMedicalInsurance,
        hasDisability,
        isFormValidated,
        submissionStatus,
        message,
        selectedCity,
        insuranceCompany,
        insuranceEndDate,
        insuranceAdditionalConditions,
        insuranceCardImagePath,
        weeklyWorkingHours,
        socialStatus,
        isEditMode,
        countriesNames,
        citiesNames,
        areasNames,
        neighborhoodsNames,
        userPersonalImage,
        disabilityLevel,
        uploadImageRequestStatus,
        profilePictureUploadedUrl,
        isPictureSelected,
      ];
}
