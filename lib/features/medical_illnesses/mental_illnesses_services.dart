import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_lens_data_request_body_model.dart';
import 'package:we_care/features/eyes/eyes_api_constants.dart';
import 'package:we_care/features/medical_illnesses/mental_illnesses_constants.dart';

part 'mental_illnesses_services.g.dart';

@RestApi(baseUrl: MentalIllnessesConstants.baseUrl)
abstract class MentalIllnessesServices {
  factory MentalIllnessesServices(Dio dio, {String? baseUrl}) =
      _MentalIllnessesServices;

  // @MultiPart()
  // @POST("http://147.93.57.70:5299/m2/api/FileUpload/upload-report")
  // Future<UploadReportResponseModel> uploadReportImage(
  //   @Part() File report,
  //   @Header("Content-Type") String contentType,
  //   @Query("language") String language,
  // );

  // @MultiPart()
  // @POST("http://147.93.57.70:5299/m2/api/FileUpload/upload-image")
  // Future<UploadImageResponseModel> uploadMedicalExaminationImage(
  //   @Part() File image,
  //   @Header("Content-Type") String contentType,
  //   @Query("language") String language,
  // );

  @POST(EyesApiConstants.postGlassesEssentialDataEntryEndPoint)
  Future<dynamic> postGlassesLensDataEntry(
    @Query("language") String language,
    @Query("UserType") String userType,
    @Body() EyeGlassesLensDataRequestBodyModel requestBody,
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

  // @POST(EyesApiConstants.postEyeDataEntry)
  // Future<dynamic> postEyeDataEntry(
  //   @Query("language") String language,
  //   @Query("UserType") String userType,
  //   @Body() EyeDataEntryRequestBody requestBody,
  // );

  // @PUT(EyesApiConstants.editEyeDataEntered)
  // Future<dynamic> editEyeDataEntered(
  //   @Query('language') String language,
  //   @Query('id') String documentId,
  //   @Query('UserType') String userType,
  //   @Body() EyeDataEntryRequestBody requestBody,
  // );

  // @PUT(EyesApiConstants.editGlassesDataEntered)
  // Future<dynamic> editGlassesDataEntered(
  //   @Body() EyeGlassesLensDataRequestBodyModel requestBody,
  //   @Query('language') String language,
  //   @Query('id') String documentId,
  //   @Query('UserType') String userType,
  // );

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
