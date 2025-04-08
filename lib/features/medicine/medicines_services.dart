import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/medicines_api_constants.dart';

part 'medicines_services.g.dart';

@RestApi(baseUrl: MedicinesApiConstants.baseUrl)
abstract class MedicinesServices {
  factory MedicinesServices(Dio dio, {String? baseUrl}) = _MedicinesServices;

  @GET(MedicinesApiConstants.getAllUserMedicines)
  Future<GetAllUserMedicinesResponseModel> getAllUserMedicines(
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
  @GET(MedicinesApiConstants.getAllMedicinesNames)
  Future<dynamic> getAllMedicinesNames(
    @Query('language') String language,
    @Query('userType') String userType,
  );
  @GET(MedicinesApiConstants.getMedicineDetailsById)
  Future<dynamic> getMedicineDetailsById(
    @Query('language') String language,
    @Query('userType') String userType,
    @Query('medicineId') String medicineId,
  );

  @GET(MedicinesApiConstants.getMedcineForms)
  Future<dynamic> getMedcineForms(
    @Query('language') String language,
    @Query('userType') String userType,
    @Query('medicineId') String medicineId,
  );
  @GET(MedicinesApiConstants.getMedcineDosesByForms)
  Future<dynamic> getMedcineDosesByForms(
    @Query('form') String form,
    @Query('language') String language,
    @Query('userType') String userType,
    @Query('medicineId') String medicineId,
  );
  @GET(MedicinesApiConstants.getAllDosageFrequencies)
  Future<dynamic> getAllDosageFrequencies(
    @Query('language') String language,
    @Query('userType') String userType,
  );
  @GET(MedicinesApiConstants.getMedicineUsageDurationCategroies)
  Future<dynamic> getAllUsageCategories(
    @Query('language') String language,
    @Query('userType') String userType,
  );
  @GET(MedicinesApiConstants.getAllDurationsForCategory)
  Future<dynamic> getAllDurationsForCategory(
    @Query('language') String language,
    @Query('userType') String userType,
    @Query('category') String category,
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
