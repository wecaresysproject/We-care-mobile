import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/global/shared_services_constants.dart';

part 'shared_services.g.dart';

@RestApi(baseUrl: SharedServicesConstants.baseUrl)
abstract class SharedServices {
  factory SharedServices(Dio dio, {String? baseUrl}) = _SharedServices;

  @GET(SharedServicesConstants.doctorSpecializations)
  Future<dynamic> getDoctorsSpecializations(
    @Query("userType") String userType,
    @Query("language") String language,
  );
  @GET(SharedServicesConstants.hospitalNames)
  Future<dynamic> getHospitalNames(
    @Query("userType") String userType,
    @Query("language") String language,
  );

  @GET(SharedServicesConstants.countryNames)
  Future<dynamic> getCountriesNames(
    @Query("userType") String userType,
    @Query('language') String language,
  );
  @GET(SharedServicesConstants.cityNames)
  Future<dynamic> getCitiesBasedOnCountryName(
    @Query("userType") String userType,
    @Query('language') String language,
    @Query('country') String country,
  );
  @GET(SharedServicesConstants.radiologyCenters)
  Future<dynamic> getRadiologyCenters(
    @Query("userType") String userType,
    @Query('language') String language,
  );
  @GET(SharedServicesConstants.labCenters)
  Future<dynamic> getLabCenters(
    @Query("userType") String userType,
    @Query('language') String language,
  );

  @GET(SharedServicesConstants.diseasesNames)
  Future<dynamic> getDiseasesNames(
    @Query("userType") String userType,
    @Query('language') String language,
  );
  @GET(SharedServicesConstants.doctorNames)
  Future<dynamic> getDoctorNames(
    @Query("userType") String userType,
    @Query('language') String language,
    @Query('specialty') String? specialization,
  );
  // @MultiPart()
  // @POST(XrayApiConstants.uploadXrayImageEndpoint)
  // Future<UploadImageResponseModel> uploadRadiologyImage(
  //   @Part() File image,
  //   @Header("Content-Type") String contentType,
  //   @Query("language") String language,
  // );

  // @MultiPart()
  // @POST(XrayApiConstants.uploadXrayReportEndpoint)
  // Future<UploadReportResponseModel> uploadRadiologyReportImage(
  //   @Part(name: 'report') File image,
  //   @Header("Content-Type") String contentType,
  //   @Query("language") String language,
  // );
}
