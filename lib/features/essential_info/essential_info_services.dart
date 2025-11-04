// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';
// import 'package:we_care/core/models/upload_image_response_model.dart';
// import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';
// import 'package:we_care/features/prescription/data/models/prescription_request_body_model.dart';
// import 'package:we_care/features/prescription/prescription_api_constants.dart';

// part 'prescription_services.g.dart';

// @RestApi(baseUrl: PrescriptionApiConstants.baseUrl)
// abstract class PrescriptionServices {
//   factory PrescriptionServices(Dio dio, {String? baseUrl}) =
//       _PrescriptionServices;

//   @GET(PrescriptionApiConstants.getCountries)
//   Future<dynamic> getCountries(@Query('language') String language);

//   @GET(PrescriptionApiConstants.getCitiesByCountryName)
//   Future<dynamic> getCitiesByCountryName(
//     @Query('language') String language,
//     @Query('country') String country,
//   );
//   @POST(PrescriptionApiConstants.postPrescriptionDataEntry)
//   Future<dynamic> postPrescriptionDataEntry(
//     @Body() PrescriptionRequestBodyModel prescriptionRequestBodyModel,
//   );

//   @MultiPart()
//   @POST(PrescriptionApiConstants.uploadPrescriptionImageEndpoint)
//   Future<UploadImageResponseModel> uploadPrescriptionImage(
//     @Part() File image,
//     @Header("Content-Type") String contentType,
//     @Query("language") String language,
//   );

//   @GET(PrescriptionApiConstants.getAllDoctors)
//   Future<dynamic> getAllDoctors(
//     @Query("usertype") String userType,
//     @Query("Language") String language,
//   );
//   @GET(PrescriptionApiConstants.getPrescriptionFilters)
//   Future<dynamic> getPrescriptionFilters(
//       @Query("language") String language, @Query("UserType") String userType);

//   @GET(PrescriptionApiConstants.getUserPrescriptionList)
//   Future<GetUserPrescriptionsResponseModel> getUserPrescriptionList(
//       @Query("language") String language, @Query("UserType") String userType,
//       {@Query("page") int? page, @Query("pageSize") int? pageSize});

//   @GET(PrescriptionApiConstants.getUserPrescriptionDetailsById)
//   Future<dynamic> getUserPrescriptionDetailsById(
//     @Query("DocumentId") String id,
//     @Query("language") String language,
//     @Query("UserType") String userType,
//   );
//   @PUT(PrescriptionApiConstants.updatePrescriptionDocumentDetails)
//   Future<dynamic> updatePrescriptionDocumentDetails(
//     @Body() PrescriptionRequestBodyModel prescriptionRequestBodyModel,
//     @Query('language') String language,
//     @Query('UserType') String userType,
//     @Query('documentId') String documentId,
//   );

//   @DELETE(PrescriptionApiConstants.deletePrescriptionById)
//   Future<dynamic> deletePrescriptionById(
//     @Query("documentId") String id,
//     @Query("language") String language,
//     @Query("UserType") String userType,
//   );

//   @GET(PrescriptionApiConstants.getFilteredPrescriptionList)
//   Future<GetUserPrescriptionsResponseModel> getFilteredPrescriptionList({
//     @Query("language") required String language,
//     @Query("doctorName") String? doctorName,
//     @Query("doctorspecialty") String? specialization,
//     @Query("year") int? year,
//     @Query("UserType") required String userType,
//   });
// }
