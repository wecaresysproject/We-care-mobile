import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/features/dental_module/data/models/get_tooth_documents_reponse_model.dart';
import 'package:we_care/features/dental_module/dental_api_constants.dart';

part 'dental_services.g.dart';

@RestApi(baseUrl: DentalApiConstants.baseUrl)
abstract class DentalService {
  factory DentalService(Dio dio, {String? baseUrl}) = _DentalService;

  @GET(DentalApiConstants.getAllCountries)
  Future<dynamic> getCountries(
    @Query('language') String language,
  );

  @MultiPart()
  @POST(DentalApiConstants.uploadReportEndpoint)
  Future<UploadReportResponseModel> uploadTeethReport(
    @Part() File report,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );

  @GET(DentalApiConstants.getAllMainMedicalProcedures)
  Future<dynamic> getAllMainMedicalProcedures(
    @Query("usertype") String userType,
    @Query("language") String language,
  );
  @GET(DentalApiConstants.getAllsecondaryMedicalProcedure)
  Future<dynamic> getAllSecondaryMedicalProcedure(
    @Query("MainProcedure") String mainProcedure,
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
  @GET(DentalApiConstants.getAllDoctors)
  Future<dynamic> getAllDoctors(
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
  @GET(DentalApiConstants.getAllComplainsDurations)
  Future<dynamic> getAllComaplainsDurations(
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
  @GET(DentalApiConstants.getAllComplainNatures)
  Future<dynamic> getAllComplainNatures(
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
  @GET(DentalApiConstants.getAllComplainTypes)
  Future<dynamic> getAllComplainTypes(
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
  @GET(DentalApiConstants.getAllGumsconditions)
  Future<dynamic> getAllGumsconditions(
    @Query("userType") String userType,
    @Query("language") String language,
  );
  @GET(DentalApiConstants.getAllOralMedicalTests)
  Future<dynamic> getAllOralMedicalTests(
    @Query("userType") String userType,
    @Query("language") String language,
  );

  @GET(DentalApiConstants.getDefectedTooth)
  Future<dynamic> getDefectedTooth(
    @Query("usertype") String userType,
    @Query("Language") String language,
  );

  @GET(DentalApiConstants.getDocumentsByToothNumber)
  Future<GetToothDocumentsResponseModel> getDocumentsByToothNumber(
    @Query("teethNumber") String toothNumber,
    @Query("usertype") String userType,
    @Query("Language") String language,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
  );

  @GET(DentalApiConstants.getToothOperationDetailsById)
  Future<dynamic> getToothOperationDetailsById(
    @Query("id") String id,
    @Query("usertype") String userType,
    @Query("Language") String language,
  );

  @DELETE(DentalApiConstants.deleteToothOperationDetailsById)
  Future<dynamic> deleteToothOperationDetailsById(
    @Query("id") String id,
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
  
  @GET(DentalApiConstants.getToothFilters)
  Future<dynamic> getToothFilters(
    @Query("usertype") String userType,
    @Query("Language") String language,
  );

  @GET(DentalApiConstants.getFilteredToothDocuments)
  Future<dynamic> getFilteredToothDocuments(
    @Query("usertype") String userType,
    @Query("Language") String language,
    @Query("teethNumber") String? teethNumber,
    @Query("year") String? year,
    @Query("subProcedure") String? procedureType,
  );

}
