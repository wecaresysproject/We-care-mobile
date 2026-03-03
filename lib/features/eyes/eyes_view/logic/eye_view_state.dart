import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_details_model.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_record_model.dart';
import 'package:we_care/features/eyes/data/models/eye_procedures_and_symptoms_details_model.dart';
import 'package:we_care/features/eyes/data/models/get_user_procedures_and_symptoms_response_model.dart';

class EyeViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<String> yearsFilter;
  final List<ProcedureAndSymptomItem> eyePartDocuments;
  final EyeProceduresAndSymptomsDetailsModel? selectedEyePartDocumentDetails;
  final List<EyeGlassesRecordModel> eyeGlassesRecords;
  final EyeGlassesDetailsModel? selectedEyeGlassesDetails;
  final bool isDeleteRequest;
  final bool isLoadingMore;
  final List<String> effectedEyeParts;
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const EyeViewState({
    this.requestStatus = RequestStatus.initial,
    this.responseMessage = '',
    this.yearsFilter = const [],
    this.eyePartDocuments = const [],
    this.selectedEyePartDocumentDetails,
    this.eyeGlassesRecords = const [],
    this.selectedEyeGlassesDetails,
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
    this.effectedEyeParts = const [],
    this.moduleGuidanceData,
  });

  EyeViewState copyWith({
    RequestStatus? requestStatus,
    String? responseMessage,
    List<String>? yearsFilter,
    List<ProcedureAndSymptomItem>? eyePartDocuments,
    EyeProceduresAndSymptomsDetailsModel? selectedEyePartDocumentDetails,
    List<EyeGlassesRecordModel>? eyeGlassesRecords,
    EyeGlassesDetailsModel? selectedEyeGlassesDetails,
    bool? isDeleteRequest,
    bool? isLoadingMore,
    List<String>? effectedEyeParts,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return EyeViewState(
      requestStatus: requestStatus ?? this.requestStatus,
      responseMessage: responseMessage ?? this.responseMessage,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      eyePartDocuments: eyePartDocuments ?? this.eyePartDocuments,
      selectedEyePartDocumentDetails:
          selectedEyePartDocumentDetails ?? this.selectedEyePartDocumentDetails,
      eyeGlassesRecords: eyeGlassesRecords ?? this.eyeGlassesRecords,
      selectedEyeGlassesDetails:
          selectedEyeGlassesDetails ?? this.selectedEyeGlassesDetails,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      effectedEyeParts: effectedEyeParts ?? this.effectedEyeParts,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        responseMessage,
        yearsFilter,
        eyePartDocuments,
        selectedEyePartDocumentDetails,
        eyeGlassesRecords,
        selectedEyeGlassesDetails,
        isDeleteRequest,
        isLoadingMore,
        effectedEyeParts,
        moduleGuidanceData,
      ];
}
