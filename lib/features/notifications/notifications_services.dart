import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/notifications/notifications_api_constants.dart';

part 'notifications_services.g.dart';

@RestApi(baseUrl: NotificationsApiConstants.baseUrl)
abstract class NotificationsServices {
  factory NotificationsServices(Dio dio, {String baseUrl}) =
      _NotificationsServices;

  @GET(NotificationsApiConstants.getNotifications)
  Future<dynamic> getNotifications(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  @GET(NotificationsApiConstants.getUnreadCount)
  Future<dynamic> getUnreadCount();

  @PUT(NotificationsApiConstants.markAsRead)
  Future<dynamic> markAsRead(@Path("id") String id);
}
