import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_details_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/answered_question_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/follow_up_record_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_request_body.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_umbrella_model.dart';

class MentalIllnessDataViewState extends Equatable {
  final RequestStatus requestStatus;
  final bool isUmbrellaMentalIllnessButtonActivated;
  final String responseMessage;
  final List<String> yearsFilter;
  final MentalIllnessRequestBody? selectedMentalIllnessDocumentDetails;
  final List<MentalIllnessModel> mentalIllnessRecords;
  final List<MentalIllnessUmbrellaModel> mentalIllnessUmbrellaRecords;
  final List<FollowUpRecordModel> followUpRecords;
  final List<AnsweredQuestionModel>? mentalIllnessAnsweredQuestions;
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
    this.mentalIllnessUmbrellaRecords = const [],
    this.mentalIllnessAnsweredQuestions = const [],
    this.followUpRecords = const [],
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
    List<MentalIllnessUmbrellaModel>? mentalIllnessUmbrellaRecords,
    List<AnsweredQuestionModel>? mentalIllnessAnsweredQuestions,
    List<FollowUpRecordModel>? followUpRecords,
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
      mentalIllnessUmbrellaRecords:
          mentalIllnessUmbrellaRecords ?? this.mentalIllnessUmbrellaRecords,
      mentalIllnessAnsweredQuestions:
          mentalIllnessAnsweredQuestions ?? this.mentalIllnessAnsweredQuestions,
      followUpRecords: followUpRecords ?? this.followUpRecords,
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
        mentalIllnessUmbrellaRecords,
        mentalIllnessAnsweredQuestions,
        followUpRecords,
      ];
}
