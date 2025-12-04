import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/home_tab/home_api_constants.dart';

part 'home_service.g.dart';

@RestApi(baseUrl: HomeApiConstants.baseUrl)
abstract class HomeService {
  factory HomeService(Dio dio, {String? baseUrl}) = _HomeService;

  @GET(HomeApiConstants.messageNotifications)
  Future<dynamic> getMessageNotifications(
    @Query("userType") String userType,
    @Query("language") String language,
  );
}
