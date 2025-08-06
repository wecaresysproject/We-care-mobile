import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'categories_services.g.dart';

@RestApi(baseUrl: "http://147.93.57.70/api/")
abstract class CategoriesServices {
  factory CategoriesServices(Dio dio, {String? baseUrl}) = _CategoriesServices;

  @GET("Ticket/count")
  Future<dynamic> getAllCategoriesTicketsCount(
    @Query('language') String language,
    @Query('userType') String userType,
  );
}
