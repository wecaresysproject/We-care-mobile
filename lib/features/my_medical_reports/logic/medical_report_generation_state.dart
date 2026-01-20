part of 'medical_report_generation_cubit.dart';

class MedicalReportGenerationState extends Equatable {
  final RequestStatus status;
  final String message;
  final bool basicInfoGetAll;
  final List<String> basicInfoSelectedValues;
  final MedicalReportResponseModel? medicalReportData;

  const MedicalReportGenerationState({
    this.status = RequestStatus.initial,
    this.message = '',
    this.basicInfoGetAll = false,
    this.basicInfoSelectedValues = const [],
    this.medicalReportData,
  });

  MedicalReportGenerationState copyWith({
    RequestStatus? status,
    String? message,
    bool? basicInfoGetAll,
    List<String>? basicInfoSelectedValues,
    MedicalReportResponseModel? medicalReportData,
  }) {
    return MedicalReportGenerationState(
      status: status ?? this.status,
      message: message ?? this.message,
      basicInfoGetAll: basicInfoGetAll ?? this.basicInfoGetAll,
      basicInfoSelectedValues:
          basicInfoSelectedValues ?? this.basicInfoSelectedValues,
      medicalReportData: medicalReportData ?? this.medicalReportData,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        basicInfoGetAll,
        basicInfoSelectedValues,
        medicalReportData,
      ];
}
