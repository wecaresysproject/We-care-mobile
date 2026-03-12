part of 'ai_consultation_cubit.dart';

class AIConsultationState extends Equatable {
  final RequestStatus status;
  final RequestStatus pdfDatesStatus;
  final RequestStatus fetchPdfStatus;
  final String message;
  final ModuleGuidanceDataModel? moduleGuidanceData;
  final List<String> reportDates;
  final UploadMedicalReportResponseModel? selectedPdf;

  const AIConsultationState({
    this.status = RequestStatus.initial,
    this.pdfDatesStatus = RequestStatus.initial,
    this.fetchPdfStatus = RequestStatus.initial,
    this.message = '',
    this.moduleGuidanceData,
    this.reportDates = const [],
    this.selectedPdf,
  });

  AIConsultationState copyWith({
    RequestStatus? status,
    RequestStatus? pdfDatesStatus,
    RequestStatus? fetchPdfStatus,
    String? message,
    ModuleGuidanceDataModel? moduleGuidanceData,
    List<String>? reportDates,
    UploadMedicalReportResponseModel? selectedPdf,
  }) {
    return AIConsultationState(
      status: status ?? this.status,
      pdfDatesStatus: pdfDatesStatus ?? this.pdfDatesStatus,
      fetchPdfStatus: fetchPdfStatus ?? this.fetchPdfStatus,
      message: message ?? this.message,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
      reportDates: reportDates ?? this.reportDates,
      selectedPdf: selectedPdf ?? this.selectedPdf,
    );
  }

  @override
  List<Object?> get props => [
        status,
        pdfDatesStatus,
        fetchPdfStatus,
        message,
        moduleGuidanceData,
        reportDates,
        selectedPdf,
      ];
}
