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

  @GET(OnlineDoctorApiConstants.getDoctorAvailability)
  Future<dynamic> getDoctorAvailability(
    @Query("doctorId") String doctorId,
  );

  @POST(OnlineDoctorApiConstants.bookAppointment)
  Future<dynamic> bookAppointment(
    @Body() Map<String, dynamic> requestBody,
  );

  @GET(OnlineDoctorApiConstants.getUpcomingBookings)
  Future<dynamic> getUpcomingBookings();

  @GET(OnlineDoctorApiConstants.getBookingsHistory)
  Future<dynamic> getBookingsHistory(
    @Query("doctorId") String? doctorId,
    @Query("specialty") String? specialty,
  );

  @GET(OnlineDoctorApiConstants.getBookingsHistoryFilters)
  Future<dynamic> getBookingsHistoryFilters();

  @GET(OnlineDoctorApiConstants.getBookingDetails)
  Future<dynamic> getBookingDetails(
    @Query("bookingId") String bookingId,
  );

  @POST(OnlineDoctorApiConstants.cancelBooking)
  Future<dynamic> cancelBooking(
    @Query("bookingId") String bookingId,
  );

  @PUT(OnlineDoctorApiConstants.rescheduleBooking)
  Future<dynamic> rescheduleBooking(
    @Query("bookingId") String bookingId,
    @Body() Map<String, dynamic> requestBody,
  );

  @PUT(OnlineDoctorApiConstants.saveBookingRating)
  Future<dynamic> saveBookingRating(
    @Query("bookingId") String bookingId,
    @Body() Map<String, dynamic> requestBody,
  );

  @PUT(OnlineDoctorApiConstants.saveBookingComment)
  Future<dynamic> saveBookingComment(
    @Query("bookingId") String bookingId,
    @Body() Map<String, dynamic> requestBody,
  );

  @GET(OnlineDoctorApiConstants.getAppointmentRoom)
  Future<dynamic> getAppointmentRoom(
    @Query("bookingId") String bookingId,
  );

  @POST(OnlineDoctorApiConstants.bookingQuestions)
  Future<dynamic> addBookingQuestion(
    @Query("bookingId") String bookingId,
    @Body() Map<String, dynamic> requestBody,
  );

  @PUT(OnlineDoctorApiConstants.bookingQuestions)
  Future<dynamic> editBookingQuestion(
    @Query("bookingId") String bookingId,
    @Query("questionId") String questionId,
    @Body() Map<String, dynamic> requestBody,
  );

  @DELETE(OnlineDoctorApiConstants.bookingQuestions)
  Future<dynamic> deleteBookingQuestion(
    @Query("bookingId") String bookingId,
    @Query("questionId") String questionId,
  );

  @POST(OnlineDoctorApiConstants.bookingParticipants)
  Future<dynamic> addBookingParticipant(
    @Query("bookingId") String bookingId,
    @Body() Map<String, dynamic> requestBody,
  );

  @DELETE(OnlineDoctorApiConstants.bookingParticipants)
  Future<dynamic> removeBookingParticipant(
    @Query("bookingId") String bookingId,
    @Query("participantId") String participantId,
  );

  @GET(OnlineDoctorApiConstants.getVideoMeeting)
  Future<dynamic> getVideoMeeting(
    @Query("appointmentId") String appointmentId,
  );
}
