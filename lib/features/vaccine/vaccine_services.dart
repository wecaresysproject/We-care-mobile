import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/vaccine/vaccine_api_constants.dart';
import 'package:we_care/features/x_ray/xray_api_constants.dart';

part 'vaccine_services.g.dart';

@RestApi(baseUrl: VaccineApiConstants.baseUrl)
abstract class VaccineApiServices {
  factory VaccineApiServices(Dio dio, {String? baseUrl}) = _VaccineApiServices;

  @GET(XrayApiConstants.getCountries)
  Future<dynamic> getCountries(@Query('language') String language);

  // @POST(XrayApiConstants.postRadiologyDataEntry)
  // Future<dynamic> postRadiologyDataEntry(
  //   @Body() XrayDataEntryRequestBodyModel xrayDataEntryRequestBodyModel,
  // );

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
