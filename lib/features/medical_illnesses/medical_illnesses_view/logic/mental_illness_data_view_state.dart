import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_details_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_request_body.dart';

class MentalIllnessDataViewState extends Equatable {
  final RequestStatus requestStatus;
  final bool isUmbrellaMentalIllnessButtonActivated;
  final String responseMessage;
  final List<String> yearsFilter;
  final MentalIllnessRequestBody? selectedMentalIllnessDocumentDetails;
  final List<MentalIllnessModel> mentalIllnessRecords;
  final EyeGlassesDetailsModel? selectedEyeGlassesDetails;
  final bool isDeleteRequest;
  final bool isLoadingMore;

  const MentalIllnessDataViewState({
    this.requestStatus = RequestStatus.initial,
    this.isUmbrellaMentalIllnessButtonActivated = true,
    this.responseMessage = '',
    this.yearsFilter = const [],
    this.selectedMentalIllnessDocumentDetails,
    this.mentalIllnessRecords = const [],
    this.selectedEyeGlassesDetails,
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
  });

  MentalIllnessDataViewState copyWith({
    RequestStatus? requestStatus,
    String? responseMessage,
    List<String>? yearsFilter,
    MentalIllnessRequestBody? selectedMentalIllnessDocumentDetails,
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
      selectedMentalIllnessDocumentDetails:
          selectedMentalIllnessDocumentDetails ??
              this.selectedMentalIllnessDocumentDetails,
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
        selectedMentalIllnessDocumentDetails,
        mentalIllnessRecords,
        selectedEyeGlassesDetails,
        isDeleteRequest,
        isLoadingMore,
        isUmbrellaMentalIllnessButtonActivated,
      ];
}
