import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_request_body_model.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_constants.dart';

part 'genetic_diseases_services.g.dart';

@RestApi(baseUrl: GeneticDiseasesConstants.baseUrl)
abstract class GeneticDiseasesServices {
  factory GeneticDiseasesServices(Dio dio, {String? baseUrl}) =
      _GeneticDiseasesServices;

  @GET(GeneticDiseasesConstants.getAllCountries)
  Future<dynamic> getCountries(
    @Query('language') String language,
  );
  @GET(GeneticDiseasesConstants.getAllDoctors)
  Future<dynamic> getAllDoctors(
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
  @GET(GeneticDiseasesConstants.getAllGeneticDiseasesClassfications)
  Future<dynamic> getAllGeneticDiseasesClassfications(
    @Query("language") String language,
  );
  @GET(GeneticDiseasesConstants.getAllGeneticDiseasesStatus)
  Future<dynamic> getAllGeneticDiseasesStatus(
    @Query("language") String language,
  );
  @GET(GeneticDiseasesConstants.getGeneticDiseasesBasedOnClassification)
  Future<dynamic> getGeneticDiseasesBasedOnClassification(
    @Query("language") String language,
    @Query("medicalClassification") String medicalClassification,
  );

  @MultiPart()
  @POST("http://147.93.57.70:5299/m2/api/FileUpload/upload-image")
  Future<UploadImageResponseModel> uploadFirstImage(
    @Part(name: "image") File image,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );
  @MultiPart()
  @POST("http://147.93.57.70/api/FileUpload/upload-image")
  Future<UploadImageResponseModel> uploadSecondImage(
    @Part(name: "image") File image,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );
  @MultiPart()
  @POST("http://147.93.57.70:5299/m2/api/FileUpload/upload-report")
  Future<UploadReportResponseModel> uploadReportImage(
    @Part(name: 'report') File image,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );

  @POST(GeneticDiseasesConstants.postGeneticDiseasesDataEntry)
  Future<dynamic> postGeneticDiseasesDataEntry(
    @Body() PersonalGeneticDiseaseRequestBodyModel requestBodyModel,
  );

  @GET(GeneticDiseasesConstants.familyMembersName)
  Future<dynamic> getFamilyMembersNames(
    @Query("language") String language,
    @Query("userType") String userType,
  );
}
