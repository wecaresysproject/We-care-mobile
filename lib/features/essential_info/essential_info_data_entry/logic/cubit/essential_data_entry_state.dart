// essential_data_entry_state.dart
part of 'essential_data_entry_cubit.dart';

/// Sentinel بيفرّق بين "الحقل مش متبعت لـ copyWith" و "متبعت null عشان يتمسح".
/// من غيره الـ `?? this.field` بيرجّع القيمة القديمة ومينفعش تمسح حقل خالص.
const Object _keepCurrentValue = Object();

class EssentialDataEntryState extends Equatable {
  final String? birthDate;
  final String? nationalIdIssueDate;
  final List<String> countriesNames;
  final List<String> citiesNames;
  final List<String> areasNames;
  final List<String> neighborhoodsNames;
  final List<String> doctors;

  // selected options
  final String? selectedGender;
  final String? selectedNationality;
  final String? selectedMaritalStatus;
  final String? selectedBloodType;
  final String? selectedDisabilityType;
  final String? selectedCity;
  final String? weeklyWorkingHours;
  final String? disabilityLevel;
  final String? socialStatus;
  final String? selectedFamilyDoctorName;

  // yes/no
  final bool? hasMedicalInsurance;
// Medical insurance section
  final String? insuranceCompany;
  final String? insuranceEndDate;
  final String? insuranceAdditionalConditions;
  final String? insuranceCardImagePath;
  final String? userPersonalImage;

  // validation + submission
  final bool isFormValidated;
  final RequestStatus submissionStatus;
  final UploadImageRequestStatus? profileImageUploadStatus;
  final UploadImageRequestStatus? insuranceImageUploadStatus;

  final String? insuranceCardPhotoUrl;
  final String? message;
  final bool isEditMode;
  final bool? isPictureSelected;

  final ModuleGuidanceDataModel? moduleGuidanceData;

  const EssentialDataEntryState({
    required this.birthDate,
    required this.nationalIdIssueDate,
    required this.selectedGender,
    required this.selectedNationality,
    required this.selectedMaritalStatus,
    required this.selectedBloodType,
    required this.selectedDisabilityType,
    required this.hasMedicalInsurance,
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
    required this.doctors,
    this.userPersonalImage,
    this.disabilityLevel,
    this.isPictureSelected,
    this.insuranceCardPhotoUrl,
    this.profileImageUploadStatus,
    this.insuranceImageUploadStatus,
    this.selectedFamilyDoctorName,
    this.moduleGuidanceData,
  });

  factory EssentialDataEntryState.initial() {
    return const EssentialDataEntryState(
      birthDate: null,
      nationalIdIssueDate: null,
      selectedGender: null,
      selectedNationality: null,
      selectedMaritalStatus: null,
      selectedBloodType: null,
      selectedDisabilityType: null,
      hasMedicalInsurance: null,
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
      doctors: [],
      userPersonalImage: null,
      disabilityLevel: null,
      profileImageUploadStatus: null,
      insuranceImageUploadStatus: null,
      isPictureSelected: null,
      insuranceCardPhotoUrl: null,
      selectedFamilyDoctorName: null,
      moduleGuidanceData: null,
    );
  }

  EssentialDataEntryState copyWith({
    String? birthDate,
    String? nationalIdIssueDate,
    String? selectedGender,
    String? selectedNationality,
    String? selectedCity,
    String? selectedMaritalStatus,
    String? selectedBloodType,
    String? selectedDisabilityType,
    bool? hasMedicalInsurance,
    bool? isFormValidated,
    RequestStatus? submissionStatus,
    String? message,
    // الحقول دى بتتمسح لما المستخدم يقول إنه ملوش تأمين، فبتاخد الـ sentinel
    Object? insuranceCompany = _keepCurrentValue,
    Object? insuranceEndDate = _keepCurrentValue,
    Object? insuranceAdditionalConditions = _keepCurrentValue,
    Object? insuranceCardImagePath = _keepCurrentValue,
    Object? insuranceCardPhotoUrl = _keepCurrentValue,
    String? weeklyWorkingHours,
    String? socialStatus,
    bool? isEditMode,
    List<String>? countriesNames,
    List<String>? citiesNames,
    List<String>? areasNames,
    List<String>? neighborhoodsNames,
    List<String>? doctors,
    String? userPersonalImage,
    String? disabilityLevel,
    UploadImageRequestStatus? profileImageUploadStatus,
    UploadImageRequestStatus? insuranceImageUploadStatus,
    bool? isPictureSelected,
    String? selectedFamilyDoctorName,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return EssentialDataEntryState(
      birthDate: birthDate ?? this.birthDate,
      nationalIdIssueDate: nationalIdIssueDate ?? this.nationalIdIssueDate,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedNationality: selectedNationality ?? this.selectedNationality,
      selectedMaritalStatus:
          selectedMaritalStatus ?? this.selectedMaritalStatus,
      selectedBloodType: selectedBloodType ?? this.selectedBloodType,
      selectedDisabilityType:
          selectedDisabilityType ?? this.selectedDisabilityType,
      hasMedicalInsurance: hasMedicalInsurance ?? this.hasMedicalInsurance,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
      selectedCity: selectedCity ?? this.selectedCity,
      insuranceCompany: identical(insuranceCompany, _keepCurrentValue)
          ? this.insuranceCompany
          : insuranceCompany as String?,
      insuranceEndDate: identical(insuranceEndDate, _keepCurrentValue)
          ? this.insuranceEndDate
          : insuranceEndDate as String?,
      insuranceAdditionalConditions:
          identical(insuranceAdditionalConditions, _keepCurrentValue)
              ? this.insuranceAdditionalConditions
              : insuranceAdditionalConditions as String?,
      insuranceCardImagePath:
          identical(insuranceCardImagePath, _keepCurrentValue)
              ? this.insuranceCardImagePath
              : insuranceCardImagePath as String?,
      weeklyWorkingHours: weeklyWorkingHours ?? this.weeklyWorkingHours,
      socialStatus: socialStatus ?? this.socialStatus,
      isEditMode: isEditMode ?? this.isEditMode,
      countriesNames: countriesNames ?? this.countriesNames,
      citiesNames: citiesNames ?? this.citiesNames,
      areasNames: areasNames ?? this.areasNames,
      neighborhoodsNames: neighborhoodsNames ?? this.neighborhoodsNames,
      doctors: doctors ?? this.doctors,
      userPersonalImage: userPersonalImage ?? this.userPersonalImage,
      disabilityLevel: disabilityLevel ?? this.disabilityLevel,
      isPictureSelected: isPictureSelected ?? this.isPictureSelected,
      insuranceCardPhotoUrl: identical(insuranceCardPhotoUrl, _keepCurrentValue)
          ? this.insuranceCardPhotoUrl
          : insuranceCardPhotoUrl as String?,
      profileImageUploadStatus:
          profileImageUploadStatus ?? this.profileImageUploadStatus,
      insuranceImageUploadStatus:
          insuranceImageUploadStatus ?? this.insuranceImageUploadStatus,
      selectedFamilyDoctorName:
          selectedFamilyDoctorName ?? this.selectedFamilyDoctorName,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
  }

  @override
  List<Object?> get props => [
        birthDate,
        nationalIdIssueDate,
        selectedGender,
        selectedNationality,
        selectedMaritalStatus,
        selectedBloodType,
        selectedDisabilityType,
        hasMedicalInsurance,
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
        doctors,
        neighborhoodsNames,
        userPersonalImage,
        disabilityLevel,
        isPictureSelected,
        insuranceCardPhotoUrl,
        profileImageUploadStatus,
        insuranceImageUploadStatus,
        selectedFamilyDoctorName,
        moduleGuidanceData,
      ];
}
