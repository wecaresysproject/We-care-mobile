import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/eyes/eyes_api_constants.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_request_body.dart';
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

  // /// 1. Get Available Years
  // @GET(EyesApiConstants.getAvailableYears)
  // Future<dynamic> getAvailableYears(
  //   @Query("language") String language,
  //   @Query("UserType") String userType,
  //   @Query("affectedEyePart") String affectedEyePart,
  // );

  // /// 2. Get All Documents (With Pagination)
  // @GET(EyesApiConstants.getAllDocuments)
  // Future<dynamic> getAllDocuments({
  //   @Query("page") required int page,
  //   @Query("limit") required int limit,
  //   @Query("language") required String language,
  //   @Query("UserType") required String userType,
  //   @Query("affectedEyePart") required String affectedEyePart,
  // });

  // /// 3. Get Filtered Documents
  // @GET(EyesApiConstants.getFilteredDocuments)
  // Future<dynamic> getFilteredDocuments(
  //   @Query("year") String? year,
  //   @Query("category") String? category,
  //   @Query("language") String language,
  //   @Query("UserType") String userType,
  //   @Query("affectedEyePart") String affectedEyePart,
  // );

  // /// 4. Get Document Details by ID
  // @GET(EyesApiConstants.getDocumentDetailsById)
  // Future<dynamic> getDocumentDetailsById(
  //   @Query("id") String id,
  //   @Query("language") String language,
  //   @Query("UserType") String userType,
  // );

  // /// 5. Delete Document by ID
  // @DELETE(EyesApiConstants.deleteDocumentById)
  // Future<dynamic> deleteDocumentById(
  //   @Query("id") String id,
  //   @Query("language") String language,
  //   @Query("UserType") String userType,
  // );

  // /// 6. Get Glasses Records (With Pagination)
  // @GET(EyesApiConstants.getGlassesRecords)
  // Future<dynamic> getAllGlasses({
  //   @Query("language") required String language,
  //   @Query("UserType") required String userType,
  //   @Query("page") required int page,
  //   @Query("limit") required int limit,
  // });

  // /// 7. Get Glasses Details by ID
  // @GET(EyesApiConstants.getGlassesDetailsById)
  // Future<dynamic> getGlassesDetailsById(
  //   @Query("id") String id,
  //   @Query("language") String language,
  //   @Query("UserType") String userType,
  // );

  // /// 8. Delete Glasses Record by ID
  // @DELETE(EyesApiConstants.deleteGlassesById)
  // Future<dynamic> deleteGlassesById(
  //   @Query("id") String id,
  //   @Query("language") String language,
  //   @Query("UserType") String userType,
  // );
}
