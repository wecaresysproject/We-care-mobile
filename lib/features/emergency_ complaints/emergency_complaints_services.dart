import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_api_constants.dart';

part 'emergency_complaints_services.g.dart';

@RestApi(baseUrl: EmergencyComplaintsApiConstants.baseUrl)
abstract class EmergencyComplaintsServices {
  factory EmergencyComplaintsServices(Dio dio, {String? baseUrl}) =
      _EmergencyComplaintsServices;
}
