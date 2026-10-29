import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/doctor/awards/data/models/awards_request_body_model.dart';
import 'package:we_care/features/doctor/bank_info/data/models/bank_info_request_body_model.dart';
import 'package:we_care/features/doctor/basic_data/data/models/doctor_basic_data_request_body_model.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/booking_settings_request_body_model.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificates_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_api_constants.dart';
import 'package:we_care/features/doctor/experience/data/models/experiences_request_body_model.dart';
import 'package:we_care/features/doctor/media_articles/data/models/media_articles_request_body_model.dart';
import 'package:we_care/features/doctor/medical_specialty/data/models/medical_specialty_request_body_model.dart';
import 'package:we_care/features/doctor/membership/data/models/memberships_request_body_model.dart';
import 'package:we_care/features/doctor/professional_licenses/data/models/licenses_request_body_model.dart';
import 'package:we_care/features/doctor/research_and_papers/data/models/research_papers_request_body_model.dart';
import 'package:we_care/features/doctor/service_prices/data/models/service_prices_request_body_model.dart';

part 'doctor_services.g.dart';

@RestApi(baseUrl: DoctorApiConstants.baseUrl)
abstract class DoctorServices {
  factory DoctorServices(Dio dio, {String baseUrl}) = _DoctorServices;

  @POST(DoctorApiConstants.postBasicData)
  Future<dynamic> postBasicData(
    @Body() DoctorBasicDataRequestBodyModel requestBody,
  );

  @POST(DoctorApiConstants.postLicenses)
  Future<dynamic> postLicenses(
    @Body() LicensesRequestBodyModel requestBody,
  );

  @POST(DoctorApiConstants.postExperiences)
  Future<dynamic> postExperiences(
    @Body() ExperiencesRequestBodyModel requestBody,
  );

  @POST(DoctorApiConstants.postCertificates)
  Future<dynamic> postCertificates(
    @Body() CertificatesRequestBodyModel requestBody,
  );

  @POST(DoctorApiConstants.postMemberships)
  Future<dynamic> postMemberships(
    @Body() MembershipsRequestBodyModel requestBody,
  );

  @POST(DoctorApiConstants.postResearchPapers)
  Future<dynamic> postResearchPapers(
    @Body() ResearchPapersRequestBodyModel requestBody,
  );

  @POST(DoctorApiConstants.postAwards)
  Future<dynamic> postAwards(
    @Body() AwardsRequestBodyModel requestBody,
  );

  @POST(DoctorApiConstants.postMediaArticles)
  Future<dynamic> postMediaArticles(
    @Body() MediaArticlesRequestBodyModel requestBody,
  );

  @POST(DoctorApiConstants.postServicePrices)
  Future<dynamic> postServicePrices(
    @Body() ServicePricesRequestBodyModel requestBody,
  );

  @POST(DoctorApiConstants.postBankInfo)
  Future<dynamic> postBankInfo(
    @Body() BankInfoRequestBodyModel requestBody,
  );

  @POST(DoctorApiConstants.postBookingSettings)
  Future<dynamic> postBookingSettings(
    @Body() BookingSettingsRequestBodyModel requestBody,
  );

  @GET(DoctorApiConstants.monthlyExaminationTargets)
  Future<dynamic> getMonthlyExaminationTargets();

  @POST(DoctorApiConstants.monthlyExaminationTargets)
  Future<dynamic> postMonthlyExaminationTarget(
    @Body() Map<String, dynamic> requestBody,
  );

  @POST(DoctorApiConstants.postMedicalSpecialty)
  Future<dynamic> postMedicalSpecialty(
    @Body() MedicalSpecialtyRequestBodyModel requestBody,
  );

  @GET(DoctorApiConstants.getDoctorBookings)
  Future<dynamic> getDoctorBookings();

  @POST(DoctorApiConstants.acceptWaitingPatient)
  Future<dynamic> acceptWaitingPatient(
    @Query("bookingId") String bookingId,
  );

  @POST(DoctorApiConstants.rejectWaitingPatient)
  Future<dynamic> rejectWaitingPatient(
    @Query("bookingId") String bookingId,
  );

  @POST(DoctorApiConstants.createVideoMeeting)
  Future<dynamic> createVideoMeeting(
    @Body() Map<String, dynamic> requestBody,
  );

  @POST(DoctorApiConstants.startVideoMeeting)
  Future<dynamic> startVideoMeeting(
    @Query("appointmentId") String appointmentId,
  );

  @POST(DoctorApiConstants.endVideoMeeting)
  Future<dynamic> endVideoMeeting(
    @Query("appointmentId") String appointmentId,
  );

  @GET(DoctorApiConstants.getBookingPatientAccess)
  Future<dynamic> getBookingPatientAccess(
    @Query("bookingId") String bookingId,
  );

  // ── Doctor profile modules: GET on the same path as each POST, returns the
  // saved data so the form opens pre-filled.

  @GET(DoctorApiConstants.postBasicData)
  Future<dynamic> getBasicData();

  @GET(DoctorApiConstants.postMedicalSpecialty)
  Future<dynamic> getMedicalSpecialty();

  @GET(DoctorApiConstants.postCertificates)
  Future<dynamic> getCertificates();

  @GET(DoctorApiConstants.postMemberships)
  Future<dynamic> getMemberships();

  @GET(DoctorApiConstants.postExperiences)
  Future<dynamic> getExperiences();

  @GET(DoctorApiConstants.postLicenses)
  Future<dynamic> getLicenses();

  @GET(DoctorApiConstants.postResearchPapers)
  Future<dynamic> getResearchPapers();

  @GET(DoctorApiConstants.postAwards)
  Future<dynamic> getAwards();

  @GET(DoctorApiConstants.postMediaArticles)
  Future<dynamic> getMediaArticles();

  @GET(DoctorApiConstants.postBankInfo)
  Future<dynamic> getBankInfo();

  @GET(DoctorApiConstants.postBookingSettings)
  Future<dynamic> getBookingSettings();

  @GET(DoctorApiConstants.postServicePrices)
  Future<dynamic> getServicePrices();
}
