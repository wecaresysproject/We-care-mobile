part of 'medical_report_generation_cubit.dart';

class MedicalReportGenerationState extends Equatable {
  final RequestStatus status;
  final Map<String, RequestStatus> categoryFiltersStatus;
  final String message;
  final bool basicInfoGetAll;
  final List<String> basicInfoSelectedValues;
  final MedicalReportResponseModel? medicalReportData;
  final Map<String, MedicalReportFilterResponseModel> categoryFilters;

  const MedicalReportGenerationState({
    this.status = RequestStatus.initial,
    this.categoryFiltersStatus = const {},
    this.message = '',
    this.basicInfoGetAll = false,
    this.basicInfoSelectedValues = const [],
    this.medicalReportData,
    this.categoryFilters = const {},
  });

  MedicalReportGenerationState copyWith({
    RequestStatus? status,
    Map<String, RequestStatus>? categoryFiltersStatus,
    String? message,
    bool? basicInfoGetAll,
    List<String>? basicInfoSelectedValues,
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
        medicalReportData,
        categoryFilters,
      ];
}
