import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/online_doctor/online_doctor_api_constants.dart';

part 'online_doctor_services.g.dart';

@RestApi(baseUrl: OnlineDoctorApiConstants.baseUrl)
abstract class OnlineDoctorServices {
  factory OnlineDoctorServices(Dio dio, {String baseUrl}) =
      _OnlineDoctorServices;

  @GET(OnlineDoctorApiConstants.getDoctorsBySpecialty)
  Future<dynamic> getDoctorsBySpecialty(
    @Query("specialty") String specialty,
  );

  @GET(OnlineDoctorApiConstants.getDoctorProfile)
  Future<dynamic> getDoctorProfile(
    @Query("doctorId") String doctorId,
  );

  @POST(OnlineDoctorApiConstants.favoriteDoctor)
  Future<dynamic> addDoctorToFavorites(
    @Query("doctorId") String doctorId,
  );

  @DELETE(OnlineDoctorApiConstants.favoriteDoctor)
  Future<dynamic> removeDoctorFromFavorites(
    @Query("doctorId") String doctorId,
  );
}
