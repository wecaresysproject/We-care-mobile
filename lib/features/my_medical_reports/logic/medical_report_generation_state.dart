part of 'medical_report_generation_cubit.dart';

class MedicalReportGenerationState extends Equatable {
  final RequestStatus status;
  final Map<String, RequestStatus> categoryFiltersStatus;
  final String message;
  final bool basicInfoGetAll;
  final List<String> basicInfoSelectedValues;
  final bool medicineGetAll;
  final List<String> medicineCurrentNames;
  final List<String> medicineExpiredNames;
  final bool chronicDiseasesGetAll;
  final List<String> chronicDiseasesSelectedValues;
  final bool urgentComplaintsGetAll;
  final List<String> urgentComplaintsSelectedYears;
  final List<String> urgentComplaintsSelectedOrgans;
  final List<String> urgentComplaintsSelectedComplaints;
  final MedicalReportResponseModel? medicalReportData;
  final Map<String, MedicalReportFilterResponseModel> categoryFilters;

  const MedicalReportGenerationState({
    this.status = RequestStatus.initial,
    this.categoryFiltersStatus = const {},
    this.message = '',
    this.basicInfoGetAll = false,
    this.basicInfoSelectedValues = const [],
    this.medicineGetAll = false,
    this.medicineCurrentNames = const [],
    this.medicineExpiredNames = const [],
    this.chronicDiseasesGetAll = false,
    this.chronicDiseasesSelectedValues = const [],
    this.urgentComplaintsGetAll = false,
    this.urgentComplaintsSelectedYears = const [],
    this.urgentComplaintsSelectedOrgans = const [],
    this.urgentComplaintsSelectedComplaints = const [],
    this.medicalReportData,
    this.categoryFilters = const {},
  });

  MedicalReportGenerationState copyWith({
    RequestStatus? status,
    Map<String, RequestStatus>? categoryFiltersStatus,
    String? message,
    bool? basicInfoGetAll,
    List<String>? basicInfoSelectedValues,
    bool? medicineGetAll,
    List<String>? medicineCurrentNames,
    List<String>? medicineExpiredNames,
    bool? chronicDiseasesGetAll,
    List<String>? chronicDiseasesSelectedValues,
    bool? urgentComplaintsGetAll,
    List<String>? urgentComplaintsSelectedYears,
    List<String>? urgentComplaintsSelectedOrgans,
    List<String>? urgentComplaintsSelectedComplaints,
    MedicalReportResponseModel? medicalReportData,
    Map<String, MedicalReportFilterResponseModel>? categoryFilters,
  }) {
    return MedicalReportGenerationState(
      status: status ?? this.status,
      categoryFiltersStatus:
          categoryFiltersStatus ?? this.categoryFiltersStatus,
      message: message ?? this.message,
      basicInfoGetAll: basicInfoGetAll ?? this.basicInfoGetAll,
      basicInfoSelectedValues:
          basicInfoSelectedValues ?? this.basicInfoSelectedValues,
      medicineGetAll: medicineGetAll ?? this.medicineGetAll,
      medicineCurrentNames: medicineCurrentNames ?? this.medicineCurrentNames,
      medicineExpiredNames: medicineExpiredNames ?? this.medicineExpiredNames,
      chronicDiseasesGetAll:
          chronicDiseasesGetAll ?? this.chronicDiseasesGetAll,
      chronicDiseasesSelectedValues:
          chronicDiseasesSelectedValues ?? this.chronicDiseasesSelectedValues,
      urgentComplaintsGetAll:
          urgentComplaintsGetAll ?? this.urgentComplaintsGetAll,
      urgentComplaintsSelectedYears:
          urgentComplaintsSelectedYears ?? this.urgentComplaintsSelectedYears,
      urgentComplaintsSelectedOrgans:
          urgentComplaintsSelectedOrgans ?? this.urgentComplaintsSelectedOrgans,
      urgentComplaintsSelectedComplaints: urgentComplaintsSelectedComplaints ??
          this.urgentComplaintsSelectedComplaints,
      medicalReportData: medicalReportData ?? this.medicalReportData,
      categoryFilters: categoryFilters ?? this.categoryFilters,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categoryFiltersStatus,
        message,
        basicInfoGetAll,
        basicInfoSelectedValues,
        medicineGetAll,
        medicineCurrentNames,
        medicineExpiredNames,
        chronicDiseasesGetAll,
        chronicDiseasesSelectedValues,
        urgentComplaintsGetAll,
        urgentComplaintsSelectedYears,
        urgentComplaintsSelectedOrgans,
        urgentComplaintsSelectedComplaints,
        medicalReportData,
        categoryFilters,
      ];
}
