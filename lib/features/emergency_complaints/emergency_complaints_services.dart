import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_api_constants.dart';

part 'emergency_complaints_services.g.dart';

@RestApi(baseUrl: EmergencyComplaintsApiConstants.baseUrl)
abstract class EmergencyComplaintsServices {
  factory EmergencyComplaintsServices(Dio dio, {String? baseUrl}) =
      _EmergencyComplaintsServices;

  @GET(EmergencyComplaintsApiConstants.getAllEmergencyComplaints)
  Future<dynamic> getAllEmergencyComplaints(
    @Query('language') String language,
  );

  @GET(EmergencyComplaintsApiConstants.getYearsFiter)
  Future<dynamic> getYearsFilter(
    @Query('language') String language,
  );

  @GET(EmergencyComplaintsApiConstants.getPlaceOfComplaintFilter)
  Future<dynamic> getPlaceOfComplaint(
    @Query('language') String language,
  );

  @GET(EmergencyComplaintsApiConstants.getFilteredList)
  Future<dynamic> getFilteredData(
    @Query('year') String? year,
    @Query('Symptoms_LocationOfPainOrComplaint') String? placeOfComplaint,
  );

  @GET(EmergencyComplaintsApiConstants.getSingleEmergencyComplaintById)
  Future<dynamic> getEmergencyComplaintById(
    @Query('id') String id,
    @Query('language') String language,
  );

  @DELETE(EmergencyComplaintsApiConstants.deleteComplaintById)
  Future<dynamic> deleteEmergencyComplaintById(
    @Query('id') String id,
  );
  @GET(EmergencyComplaintsApiConstants.getAllPlacesOfComplaints)
  Future<dynamic> getAllPlacesOfComplaints(@Query('language') String language);
}
