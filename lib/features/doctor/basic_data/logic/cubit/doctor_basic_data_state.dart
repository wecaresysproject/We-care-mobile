part of 'doctor_basic_data_cubit.dart';

/// Sentinel distinguishing "field not passed to copyWith" from "passed as
/// null to clear it" — without it `?? this.field` can never clear a field.
const Object _unset = Object();

class DoctorBasicDataState extends Equatable {
  const DoctorBasicDataState({
    required this.countriesNames,
    required this.citiesNames,
    required this.selectedJobGrade,
    required this.selectedAcademicDegree,
    required this.selectedGender,
    required this.birthDate,
    required this.selectedCountry,
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.professionalMobileCountryCode,
    required this.contactMobileCountryCode,
    required this.selectedLanguages,
    required this.profileImageUrl,
    required this.profileImageUploadStatus,
    required this.nationalIdImageUrl,
    required this.nationalIdImageUploadStatus,
    required this.submissionStatus,
    required this.message,
  });

  factory DoctorBasicDataState.initial() => const DoctorBasicDataState(
        countriesNames: [],
        citiesNames: [],
        selectedJobGrade: null,
        selectedAcademicDegree: null,
        selectedGender: null,
        birthDate: null,
        selectedCountry: null,
        selectedGovernorate: null,
        selectedCity: null,
        professionalMobileCountryCode: '+20',
        contactMobileCountryCode: '+20',
        selectedLanguages: [],
        profileImageUrl: null,
        profileImageUploadStatus: null,
        nationalIdImageUrl: null,
        nationalIdImageUploadStatus: null,
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  final List<String> countriesNames;
  final List<String> citiesNames;

  final String? selectedJobGrade;
  final String? selectedAcademicDegree;
  final String? selectedGender;
  final String? birthDate;
  final String? selectedCountry;
  final String? selectedGovernorate;
  final String? selectedCity;
  final String professionalMobileCountryCode;
  final String contactMobileCountryCode;
  final List<String> selectedLanguages;

  final String? profileImageUrl;
  final UploadImageRequestStatus? profileImageUploadStatus;
  final String? nationalIdImageUrl;
  final UploadImageRequestStatus? nationalIdImageUploadStatus;

  final RequestStatus submissionStatus;
  final String? message;

  DoctorBasicDataState copyWith({
    List<String>? countriesNames,
    List<String>? citiesNames,
    Object? selectedJobGrade = _unset,
    Object? selectedAcademicDegree = _unset,
    Object? selectedGender = _unset,
    Object? birthDate = _unset,
    Object? selectedCountry = _unset,
    Object? selectedGovernorate = _unset,
    Object? selectedCity = _unset,
    String? professionalMobileCountryCode,
    String? contactMobileCountryCode,
    List<String>? selectedLanguages,
    Object? profileImageUrl = _unset,
    UploadImageRequestStatus? profileImageUploadStatus,
    Object? nationalIdImageUrl = _unset,
    UploadImageRequestStatus? nationalIdImageUploadStatus,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return DoctorBasicDataState(
      countriesNames: countriesNames ?? this.countriesNames,
      citiesNames: citiesNames ?? this.citiesNames,
      selectedJobGrade: identical(selectedJobGrade, _unset)
          ? this.selectedJobGrade
          : selectedJobGrade as String?,
      selectedAcademicDegree: identical(selectedAcademicDegree, _unset)
          ? this.selectedAcademicDegree
          : selectedAcademicDegree as String?,
      selectedGender: identical(selectedGender, _unset)
          ? this.selectedGender
          : selectedGender as String?,
      birthDate:
          identical(birthDate, _unset) ? this.birthDate : birthDate as String?,
      selectedCountry: identical(selectedCountry, _unset)
          ? this.selectedCountry
          : selectedCountry as String?,
      selectedGovernorate: identical(selectedGovernorate, _unset)
          ? this.selectedGovernorate
          : selectedGovernorate as String?,
      selectedCity: identical(selectedCity, _unset)
          ? this.selectedCity
          : selectedCity as String?,
      professionalMobileCountryCode:
          professionalMobileCountryCode ?? this.professionalMobileCountryCode,
      contactMobileCountryCode:
          contactMobileCountryCode ?? this.contactMobileCountryCode,
      selectedLanguages: selectedLanguages ?? this.selectedLanguages,
      profileImageUrl: identical(profileImageUrl, _unset)
          ? this.profileImageUrl
          : profileImageUrl as String?,
      profileImageUploadStatus:
          profileImageUploadStatus ?? this.profileImageUploadStatus,
      nationalIdImageUrl: identical(nationalIdImageUrl, _unset)
          ? this.nationalIdImageUrl
          : nationalIdImageUrl as String?,
      nationalIdImageUploadStatus:
          nationalIdImageUploadStatus ?? this.nationalIdImageUploadStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        countriesNames,
        citiesNames,
        selectedJobGrade,
        selectedAcademicDegree,
        selectedGender,
        birthDate,
        selectedCountry,
        selectedGovernorate,
        selectedCity,
        professionalMobileCountryCode,
        contactMobileCountryCode,
        selectedLanguages,
        profileImageUrl,
        profileImageUploadStatus,
        nationalIdImageUrl,
        nationalIdImageUploadStatus,
        submissionStatus,
        message,
      ];
}
