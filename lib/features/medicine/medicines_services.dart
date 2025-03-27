import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/medicine/medicines_api_constants.dart';

part 'medicines_services.g.dart';

@RestApi(baseUrl: MedicinesApiConstants.baseUrl)
abstract class MedicinesServices {
  factory MedicinesServices(Dio dio, {String? baseUrl}) = _MedicinesServices;

  // @GET(EmergencyComplaintsApiConstants.getAllEmergencyComplaints)
  // Future<dynamic> getAllEmergencyComplaints(
  //   @Query('language') String language,
  // );

  @GET(MedicinesApiConstants.getAllPlacesOfComplaints)
  Future<dynamic> getAllPlacesOfComplaints(@Query('language') String language);

  @GET(MedicinesApiConstants.getRelevantComplaintsToBodyPartName)
  Future<dynamic> getAllComplaintsRelevantToBodyPartName(
    @Query('bodyPartName') String bodyPartName,
  );

  // @POST(EmergencyComplaintsApiConstants.postDataEntryEndpoint)
  // Future<dynamic> postEmergencyDataEntry(
  //   @Body() EmergencyComplainRequestBody requestBody,
  //   @Query('language') String language,
  // );

  // @PUT(EmergencyComplaintsApiConstants.editSpecificComplaintDocumentDetail)
  // Future<dynamic> editSpecifcEmergencyDocumentDataDetails(
  //   @Body() EmergencyComplainRequestBody requestBody,
  //   @Query('language') String language,
  //   @Query('id') String documentId,
  // );
}
