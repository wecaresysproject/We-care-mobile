part of 'medical_report_generation_cubit.dart';

class MedicalReportGenerationState extends Equatable {
  final RequestStatus status;
  final Map<String, RequestStatus> categoryFiltersStatus;
  final String message;
  final bool basicInfoGetAll;
  final List<String> basicInfoSelectedValues;
  final bool medicineGetAll;
  final List<String> medicineCurrentNames;
  final List<String> medicineCurrentYears;
  final List<String> medicineExpiredNames;
  final List<String> medicineExpiredYears;
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
    this.medicineCurrentYears = const [],
    this.medicineExpiredNames = const [],
    this.medicineExpiredYears = const [],
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
    List<String>? medicineCurrentYears,
    List<String>? medicineExpiredNames,
    List<String>? medicineExpiredYears,
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
      medicineCurrentYears: medicineCurrentYears ?? this.medicineCurrentYears,
      medicineExpiredNames: medicineExpiredNames ?? this.medicineExpiredNames,
      medicineExpiredYears: medicineExpiredYears ?? this.medicineExpiredYears,
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
        medicineCurrentYears,
        medicineExpiredNames,
        medicineExpiredYears,
        medicalReportData,
        categoryFilters,
      ];
}
