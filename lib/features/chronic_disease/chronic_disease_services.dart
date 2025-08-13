import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_api_constants.dart';
import 'package:we_care/features/chronic_disease/data/models/post_chronic_disease_model.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';
import 'package:we_care/features/prescription/data/models/prescription_request_body_model.dart';

part 'chronic_disease_services.g.dart';

@RestApi(baseUrl: ChronicDiseaseApiConstants.baseUrl)
abstract class ChronicDiseaseServices {
  factory ChronicDiseaseServices(Dio dio, {String? baseUrl}) =
      _ChronicDiseaseServices;

  @GET(ChronicDiseaseApiConstants.getChronicDiseasesNames)
  Future<dynamic> getChronicDiseasesNames(
    @Query('language') String language,
  );

  @POST(ChronicDiseaseApiConstants.postChrconicDiseaseData)
  Future<dynamic> postChronicDiseaseData(
    @Body() PostChronicDiseaseModel requestbody,
    @Query('language') String language,
  );

  // @GET(ChronicDiseaseApiConstants.getPrescriptionFilters)
  // Future<dynamic> getPrescriptionFilters(
  //     @Query("language") String language, @Query("UserType") String userType);

  @GET(ChronicDiseaseApiConstants.getUserPrescriptionList)
  Future<GetUserPrescriptionsResponseModel> getUserPrescriptionList(
      @Query("language") String language, @Query("UserType") String userType,
      {@Query("page") int? page, @Query("pageSize") int? pageSize});

  @GET(ChronicDiseaseApiConstants.getUserPrescriptionDetailsById)
  Future<dynamic> getUserPrescriptionDetailsById(
    @Query("DocumentId") String id,
    @Query("language") String language,
    @Query("UserType") String userType,
  );
  @PUT(ChronicDiseaseApiConstants.updatePrescriptionDocumentDetails)
  Future<dynamic> updatePrescriptionDocumentDetails(
    @Body() PrescriptionRequestBodyModel prescriptionRequestBodyModel,
    @Query('language') String language,
    @Query('UserType') String userType,
    @Query('documentId') String documentId,
  );

  @DELETE(ChronicDiseaseApiConstants.deletePrescriptionById)
  Future<dynamic> deletePrescriptionById(
    @Query("documentId") String id,
    @Query("language") String language,
    @Query("UserType") String userType,
  );

  // @GET(ChronicDiseaseApiConstants.getFilteredPrescriptionList)
  // Future<GetUserPrescriptionsResponseModel> getFilteredPrescriptionList({
  //   @Query("language") required String language,
  //   @Query("doctorName") String? doctorName,
  //   @Query("doctorspecialty") String? specialization,
  //   @Query("year") int? year,
  //   @Query("UserType") required String userType,
  // });
}
