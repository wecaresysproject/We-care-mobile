import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/medicines_api_constants.dart';

part 'medicines_services.g.dart';

@RestApi(baseUrl: MedicinesApiConstants.baseUrl)
abstract class MedicinesServices {
  factory MedicinesServices(Dio dio, {String? baseUrl}) = _MedicinesServices;

  @GET(MedicinesApiConstants.getAllMedicines)
  Future<GetAllUserMedicinesResponseModel> getAllMedicines(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicinesApiConstants.getSingleMedicine)
  Future<dynamic> getSingleMedicine(
    @Query('medicineId') String id,
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @DELETE(MedicinesApiConstants.deletemedicineById)
  Future<dynamic> deleteMedicineById(
    @Query("medicineId") String id,
    @Query("language") String language,
    @Query("userType") String userType,
  );

  @GET(MedicinesApiConstants.getFilteredMedicines)
  Future<GetAllUserMedicinesResponseModel> getFilteredMedicines(
    @Query('language') String language,
    @Query('userType') String userType,
    @Query('year') int? year,
    @Query('medicineName') String? medicineName,
  );

  @GET(MedicinesApiConstants.getFilters)
  Future<dynamic> getMedicinesFilters(
      @Query('language') String language, @Query('userType') String userType);

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
