import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/essential_info/data/models/user_essential_info_request_body_model.dart';
import 'package:we_care/features/essential_info/essential_info_api_constants.dart';

part 'essential_info_services.g.dart';

@RestApi(baseUrl: EssentialInfoApiConstants.baseUrl)
abstract class EssentialInfoServices {
  factory EssentialInfoServices(Dio dio, {String? baseUrl}) =
      _EssentialInfoServices;

  @GET(EssentialInfoApiConstants.getUserEssentialInfo)
  Future<dynamic> getEssentialInfo(
      @Query("language") String language, @Query("userType") String userType);

  @DELETE(EssentialInfoApiConstants.deleteUserEssentialInfo)
  Future<dynamic> deleteEssentialInfo(
    @Query("language") String language,
    @Query("userType") String userType,
    @Query("documentId") String id,
  );

  @POST(EssentialInfoApiConstants.postUserEssentialInfo)
  Future<dynamic> postUserEssentialInfo(
    @Body() UserEssentialInfoRequestBodyModel requestBody,
    @Query('language') String language,
    @Query('userType') String userType,
  );
  @PUT(EssentialInfoApiConstants.updateUserEssentialInfo)
  Future<dynamic> updateUserEssentialInfo(
    @Body() UserEssentialInfoRequestBodyModel requestBody,
    @Query('language') String language,
    @Query('userType') String userType,
  );
}
