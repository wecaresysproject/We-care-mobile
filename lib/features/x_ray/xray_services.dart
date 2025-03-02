import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/x_ray/data/models/user_radiology_data_reponse_model.dart';
import 'package:we_care/features/x_ray/xray_api_constants.dart';

part 'xray_services.g.dart';

@RestApi(baseUrl: XrayApiConstants.baseUrl)
abstract class XRayApiServices {
  factory XRayApiServices(Dio dio, {String? baseUrl}) = _XRayApiServices;

  @GET(XrayApiConstants.getUserRadiologysData)
  Future<UserRadiologyDataResponse> getUserRadiologyData(
      @Query("language") String language, @Query("UserType") String userType);

  @GET(XrayApiConstants.getSpecificUserRadiologyDocument)
  Future<dynamic> getSpecificUserRadiologyDocument(
      @Query("documentId") String id,
      @Query("language") String language,
      @Query("UserType") String userType);

  @GET(XrayApiConstants.getFilters)
  Future<dynamic> gettFilters(@Query("language") String language);

  @GET('/RadiologyUserEntryPage/RadiologySearchUserDocuments')
  Future<UserRadiologyDataResponse> getFilteredData(
      @Query("language") String language,
      @Query("year") int? year,
      @Query("radioType") String? radioType,
      @Query("bodyPart") String? bodyPart);
}
