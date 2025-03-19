import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';
import 'package:we_care/features/vaccine/data/models/vaccine_request_body_model.dart';
import 'package:we_care/features/vaccine/vaccine_api_constants.dart';

part 'vaccine_services.g.dart';

@RestApi(baseUrl: VaccineApiConstants.baseUrl)
abstract class VaccineApiServices {
  factory VaccineApiServices(Dio dio, {String? baseUrl}) = _VaccineApiServices;

  @GET(VaccineApiConstants.getCountries)
  Future<dynamic> getCountries(@Query('language') String language);

  @GET(VaccineApiConstants.getvaccineCategories)
  Future<dynamic> getVaccineCategories(
    @Query('language') String language,
    @Query('UserType') String userType,
  );
  @GET(VaccineApiConstants.getSpecificVaccinesResultsUsingSelectedCategory)
  Future<dynamic> getVaccineResultsByCategoryName(
    @Query('vaccineCategory') String vaccineCategory,
    @Query('language') String language,
    @Query('UserType') String userType,
  );

  @GET(VaccineApiConstants.getUserVaccines)
  Future<GetUserVaccinesResponseModel> getUserVaccines(
      @Query('language') String language, @Query('userType') String userType);

  @GET(VaccineApiConstants.getVaccinesFilters)
  Future<dynamic> getVaccinesFilters(
      @Query('language') String language, @Query('userType') String userType);

  @GET(VaccineApiConstants.getFilteredList)
  Future<GetUserVaccinesResponseModel> getFilteredList(
    @Query('lang') String language,
    @Query('UserType') String userType,
    @Query('vaccineName') String? vaccineName,
    @Query('year') String? year,
  );

  @GET(VaccineApiConstants.getVaccineById)
  Future<dynamic> getVaccineById(
    @Query('language') String language,
    @Query('vaccineId') String vaccineId,
    @Query('userType') String userType,
  );

  @DELETE(VaccineApiConstants.deleteVaccineById)
  Future<dynamic> deleteVaccine(
    @Query('language') String language,
    @Query('vaccineId') String vaccineId,
    @Query('userType') String userType,
  );

  @POST(VaccineApiConstants.postVaccineDataEntry)
  Future<dynamic> postVaccineDataEntry(
    @Body() VaccineModuleRequestBody requestBody,
    @Query('language') String language,
    @Query('UserType') String userType,
  );
}
