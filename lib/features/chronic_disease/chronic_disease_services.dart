import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_api_constants.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';
import 'package:we_care/features/prescription/data/models/prescription_request_body_model.dart';

part 'chronic_disease_services.g.dart';

@RestApi(baseUrl: ChronicDiseaseApiConstants.baseUrl)
abstract class ChronicDiseaseServices {
  factory ChronicDiseaseServices(Dio dio, {String? baseUrl}) =
      _ChronicDiseaseServices;

  @GET(ChronicDiseaseApiConstants.getCountries)
  Future<dynamic> getCountries(@Query('language') String language);

  @GET(ChronicDiseaseApiConstants.getCitiesByCountryName)
  Future<dynamic> getCitiesByCountryName(
    @Query('language') String language,
    @Query('country') String country,
  );
  @POST(ChronicDiseaseApiConstants.postPrescriptionDataEntry)
  Future<dynamic> postPrescriptionDataEntry(
    @Body() PrescriptionRequestBodyModel prescriptionRequestBodyModel,
  );

  @GET(ChronicDiseaseApiConstants.getPrescriptionFilters)
  Future<dynamic> getPrescriptionFilters(
      @Query("language") String language, @Query("UserType") String userType);

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
