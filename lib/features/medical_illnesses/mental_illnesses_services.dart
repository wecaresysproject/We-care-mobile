import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/eyes/eyes_api_constants.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_request_body.dart';
import 'package:we_care/features/medical_illnesses/data/models/post_fcm_token_request_model.dart';
import 'package:we_care/features/medical_illnesses/mental_illnesses_constants.dart';

part 'mental_illnesses_services.g.dart';

@RestApi(baseUrl: MentalIllnessesConstants.baseUrl)
abstract class MentalIllnessesServices {
  factory MentalIllnessesServices(Dio dio, {String? baseUrl}) =
      _MentalIllnessesServices;

  @POST(MentalIllnessesConstants.postMentalIlnessDataEntryEndPoint)
  Future<dynamic> postMentalIlnessDataEntryEndPoint(
    @Query("userType") String userType,
    @Query("language") String language,
    @Body() MentalIllnessRequestBody requestBody,
  );
  @POST(MentalIllnessesConstants.postQuestionnaireAnswers)
  Future<dynamic> postQuestionnaireAnswers(
    @Query("userType") String userType,
    @Query("language") String language,
    @Body() List<FcmQuestionModel> questions,
  );

  @GET(EyesApiConstants.getAllDoctors)
  Future<dynamic> getAllDoctors(
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
  @GET(EyesApiConstants.getAllCountries)
  Future<dynamic> getCountries(
    @Query('language') String language,
  );
  //!New
  @GET(MentalIllnessesConstants.getMentalIllnessTypes)
  Future<dynamic> getMentalIllnessTypes(
    @Query("userType") String userType,
    @Query("language") String language,
  );

  @GET(MentalIllnessesConstants.getIncidentTypes)
  Future<dynamic> getIncidentTypes(
    @Query("userType") String userType,
    @Query("language") String language,
  );
  @GET(MentalIllnessesConstants.getMedicationImpactOnDailyLife)
  Future<dynamic> getMedicationImpactOnDailyLife(
    @Query("userType") String userType,
    @Query("language") String language,
  );
  @GET(MentalIllnessesConstants.getPsychologicalEmergencies)
  Future<dynamic> getPsychologicalEmergencies(
    @Query("userType") String userType,
    @Query("language") String language,
  );
  @GET(MentalIllnessesConstants.getMedicationSideEffects)
  Future<dynamic> getMedicationSideEffects(
    @Query("userType") String userType,
    @Query("language") String language,
  );
  @GET(MentalIllnessesConstants
      .getPreferredActivitiesForPsychologicalImprovement)
  Future<dynamic> getPreferredActivitiesForPsychologicalImprovement(
    @Query("userType") String userType,
    @Query("language") String language,
  );

  @PUT(MentalIllnessesConstants.editMentalIlnessDataEntryEndPoint)
  Future<dynamic> editMentalIllnessDataEntered(
    @Query("userType") String userType,
    @Query("language") String language,
    @Query('id') String documentId,
    @Body() MentalIllnessRequestBody requestBody,
  );
  //! Data View
  //! 1.

  @GET(MentalIllnessesConstants.getIsUmbrellaMentalIllnessButtonActivated)
  Future<dynamic> getIsUmbrellaMentalIllnessButtonActivated();

  //! 2.
  @GET(MentalIllnessesConstants.getMedicalIllnessDocsAvailableYears)
  Future<dynamic> getMedicalIllnessDocsAvailableYears(
    @Query("language") String language,
    @Query("userType") String userType,
  );
  //! 3. getMentalIllnessRecords  (With Pagination)
  @GET(MentalIllnessesConstants.getMentalIllnessRecords)
  Future<dynamic> getMentalIllnessRecords({
    @Query("language") required String language,
    @Query("userType") required String userType,
    @Query("page") required int page,
    @Query("limit") required int limit,
  });
  //! 4.

  @GET(MentalIllnessesConstants.getFilteredMentalIllnessDocuments)
  Future<dynamic> getFilteredMentalIllnessDocuments(
    @Query("year") String? year,
    @Query("language") String language,
    @Query("userType") String userType,
  );

  //! 5
  @GET(MentalIllnessesConstants.getMentalIllnessDocumentDetailsById)
  Future<dynamic> getMentalIllnessDocumentDetailsById(
    @Query("id") String id,
    @Query("language") String language,
    @Query("userType") String userType,
  );

  //! 6.
  @DELETE(MentalIllnessesConstants.deleteMentalIllnessDetailsDocumentById)
  Future<dynamic> deleteMentalIllnessDetailsDocumentById(
    @Query("id") String id,
    @Query("language") String language,
    @Query("userType") String userType,
  );
  //! 7.

  @GET(MentalIllnessesConstants.getMedicalIllnessUmbrellaDocs)
  Future<dynamic> getMedicalIllnessUmbrellaDocs({
    @Query("language") required String language,
    @Query("userType") required String userType,
    @Query("page") required int page,
    @Query("limit") required int limit,
  });
  //! 8.

  @GET(MentalIllnessesConstants.getAllAnsweredQuestions)
  Future<dynamic> getAllAnsweredQuestions({
    @Query("language") required String language,
    @Query("userType") required String userType,
  });
  //! 9.

  @GET(MentalIllnessesConstants.getFollowUpReportsAvailableYears)
  Future<dynamic> getFollowUpReportsAvailableYears(
    @Query("language") String language,
    @Query("userType") String userType,
  );
  //! 10.

  @GET(MentalIllnessesConstants.getFilteredFollowUpReports)
  Future<dynamic> getFilteredFollowUpReports(
    @Query("year") String? year,
    @Query("language") String language,
    @Query("userType") String userType,
  );
  //! 11.

  @GET(MentalIllnessesConstants.getAllFollowUpReportsRecords)
  Future<dynamic> getAllFollowUpReportsRecords({
    @Query("language") required String language,
    @Query("userType") required String userType,
    @Query("page") required int page,
    @Query("limit") required int limit,
  });
  //! 12.
  @GET(MentalIllnessesConstants.getFollowUpDocumentDetailsById)
  Future<dynamic> getFollowUpDocumentDetailsById(
    @Query("id") String id,
    @Query("language") String language,
    @Query("userType") String userType,
  );

  @POST(MentalIllnessesConstants.postActivationOfUmbrella)
  Future<dynamic> postActivationOfUmbrella(
    @Query("userType") String userType,
    @Query("language") String language,
    @Body() PostFcmTokenRequest requestBody,
  );

  @GET(MentalIllnessesConstants.getActivationOfUmbrella)
  Future<dynamic> getActivationOfUmbrella(
    @Query("userType") String userType,
    @Query("language") String language,
  );
}
