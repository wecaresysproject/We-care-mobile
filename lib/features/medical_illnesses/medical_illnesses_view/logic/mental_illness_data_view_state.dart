import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_details_model.dart';
import 'package:we_care/features/eyes/data/models/eye_procedures_and_symptoms_details_model.dart';
import 'package:we_care/features/eyes/data/models/get_user_procedures_and_symptoms_response_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_model.dart';

class MentalIllnessDataViewState extends Equatable {
  final RequestStatus requestStatus;
  final bool isUmbrellaMentalIllnessButtonActivated;
  final String responseMessage;
  final List<String> yearsFilter;
  final List<ProcedureAndSymptomItem> eyePartDocuments;
  final EyeProceduresAndSymptomsDetailsModel? selectedEyePartDocumentDetails;
  final List<MentalIllnessModel> mentalIllnessRecords;
  final EyeGlassesDetailsModel? selectedEyeGlassesDetails;
  final bool isDeleteRequest;
  final bool isLoadingMore;

  const MentalIllnessDataViewState({
    this.requestStatus = RequestStatus.initial,
    this.isUmbrellaMentalIllnessButtonActivated = true,
    this.responseMessage = '',
    this.yearsFilter = const [],
    this.eyePartDocuments = const [],
    this.selectedEyePartDocumentDetails,
    this.mentalIllnessRecords = const [],
    this.selectedEyeGlassesDetails,
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
  });

  MentalIllnessDataViewState copyWith({
    RequestStatus? requestStatus,
    String? responseMessage,
    List<String>? yearsFilter,
    List<ProcedureAndSymptomItem>? eyePartDocuments,
    EyeProceduresAndSymptomsDetailsModel? selectedEyePartDocumentDetails,
    List<MentalIllnessModel>? mentalIllnessRecords,
    EyeGlassesDetailsModel? selectedEyeGlassesDetails,
    bool? isDeleteRequest,
    bool? isLoadingMore,
    bool? isUmbrellaMentalIllnessButtonActivated,
  }) {
    return MentalIllnessDataViewState(
      requestStatus: requestStatus ?? this.requestStatus,
      responseMessage: responseMessage ?? this.responseMessage,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      eyePartDocuments: eyePartDocuments ?? this.eyePartDocuments,
      selectedEyePartDocumentDetails:
          selectedEyePartDocumentDetails ?? this.selectedEyePartDocumentDetails,
      mentalIllnessRecords: mentalIllnessRecords ?? this.mentalIllnessRecords,
      selectedEyeGlassesDetails:
          selectedEyeGlassesDetails ?? this.selectedEyeGlassesDetails,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isUmbrellaMentalIllnessButtonActivated:
          isUmbrellaMentalIllnessButtonActivated ??
              this.isUmbrellaMentalIllnessButtonActivated,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        responseMessage,
        yearsFilter,
        eyePartDocuments,
        selectedEyePartDocumentDetails,
        mentalIllnessRecords,
        selectedEyeGlassesDetails,
        isDeleteRequest,
        isLoadingMore,
        isUmbrellaMentalIllnessButtonActivated,
      ];
}
