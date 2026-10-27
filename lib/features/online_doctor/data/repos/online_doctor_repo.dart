import 'package:dio/dio.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/allowed_care_access/data/models/search_phone_number_response.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_room_model.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_slot_model.dart';
import 'package:we_care/features/online_doctor/data/models/book_appointment_request.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_filters_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_summary_model.dart';
import 'package:we_care/features/online_doctor/data/models/video_meeting_model.dart';
import 'package:we_care/features/online_doctor/online_doctor_services.dart';

class OnlineDoctorRepo {
  final OnlineDoctorServices _onlineDoctorServices;

  OnlineDoctorRepo({required OnlineDoctorServices onlineDoctorServices})
      : _onlineDoctorServices = onlineDoctorServices;

  Future<ApiResult<List<DoctorSummaryModel>>> getDoctorsBySpecialty({
    required String specialty,
  }) async {
    try {
      final response =
          await _onlineDoctorServices.getDoctorsBySpecialty(specialty);
      final doctors = (response['data'] as List? ?? const [])
          .map((e) => DoctorSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(doctors);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<DoctorModel>> getDoctorProfile({
    required String doctorId,
  }) async {
    try {
      final response = await _onlineDoctorServices.getDoctorProfile(doctorId);
      return ApiResult.success(
        DoctorModel.fromProfileJson(
          response['data'] as Map<String, dynamic>,
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// بيضيف الطبيب للمفضلة لو [isFavorite] = `true` أو بيشيله لو `false`،
  /// وبيرجّع الحالة النهائية زى ما الـ API بيأكدها.
  Future<ApiResult<bool>> setDoctorFavorite({
    required String doctorId,
    required bool isFavorite,
  }) async {
    try {
      final response = isFavorite
          ? await _onlineDoctorServices.addDoctorToFavorites(doctorId)
          : await _onlineDoctorServices.removeDoctorFromFavorites(doctorId);
      final data = response is Map ? response['data'] : null;
      final confirmed = data is Map ? data['isFavorite'] : null;
      return ApiResult.success(confirmed is bool ? confirmed : isFavorite);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// الأيام اللى فيها مواعيد فاضية وتوقيتاتها — الـ API بيرجّع الفاضى بس
  /// ومرتب من الأقرب للأبعد.
  Future<ApiResult<List<AppointmentDayModel>>> getDoctorAvailability({
    required String doctorId,
  }) async {
    try {
      final response =
          await _onlineDoctorServices.getDoctorAvailability(doctorId);
      final days = (response['data'] as List? ?? const [])
          .map((e) => AppointmentDayModel.fromJson(e as Map<String, dynamic>))
          .where((day) => day.slots.isNotEmpty)
          .toList();
      return ApiResult.success(days);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> bookAppointment({
    required BookAppointmentRequest request,
  }) async {
    try {
      await _onlineDoctorServices.bookAppointment(request.toJson());
      return const ApiResult.success(true);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// المواعيد اللى لسه مخلصتش — شاملة اللى بدأت ولسه فى وقتها.
  Future<ApiResult<List<BookingModel>>> getUpcomingBookings() async {
    try {
      final response = await _onlineDoctorServices.getUpcomingBookings();
      final bookings = (response['data'] as List? ?? const [])
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(bookings);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// السجل السابق مرتب من الأحدث للأقدم — [doctorId] و[specialty] اختياريين،
  /// ولو الاتنين اتبعتوا النتيجة لازم تطابقهم مع بعض.
  Future<ApiResult<List<BookingHistoryModel>>> getBookingsHistory({
    String? doctorId,
    String? specialty,
  }) async {
    try {
      final response =
          await _onlineDoctorServices.getBookingsHistory(doctorId, specialty);
      final bookings = (response['data'] as List? ?? const [])
          .map((e) => BookingHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(bookings);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// الأطباء والتخصصات الموجودين فى سجل المريض نفسه — لقوايم الفلترين.
  Future<ApiResult<BookingHistoryFiltersModel>>
      getBookingsHistoryFilters() async {
    try {
      final response = await _onlineDoctorServices.getBookingsHistoryFilters();
      return ApiResult.success(
        BookingHistoryFiltersModel.fromJson(
          response['data'] as Map<String, dynamic>? ?? const {},
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<BookingHistoryModel>> getBookingDetails({
    required String bookingId,
  }) async {
    try {
      final response = await _onlineDoctorServices.getBookingDetails(bookingId);
      return ApiResult.success(
        BookingHistoryModel.fromJson(response['data'] as Map<String, dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> cancelBooking({required String bookingId}) async {
    try {
      await _onlineDoctorServices.cancelBooking(bookingId);
      return const ApiResult.success(true);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// بينقل الحجز لميعاد [slot] فى يوم [day] وبيرجّع الحجز بعد التعديل زى ما
  /// الـ API بيأكده — أو `null` لو الرد مرجّعش الحجز، والميعاد بيتحدّث محليًا.
  Future<ApiResult<BookingModel?>> rescheduleBooking({
    required String bookingId,
    required AppointmentDayModel day,
    required AppointmentTimeSlot slot,
  }) async {
    try {
      final response = await _onlineDoctorServices.rescheduleBooking(
        bookingId,
        {"date": day.apiDate, "startTime": slot.apiStartTime},
      );
      final data = response is Map ? response['data'] : null;
      return ApiResult.success(
        data is Map<String, dynamic> && data['startsAt'] is String
            ? BookingModel.fromJson(data)
            : null,
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// بيحفظ تقييم المريض للموعد (أول مرة أو تعديل) وبيرجّع الموعد بالتقييم
  /// وتاريخه زى ما الـ API بيأكدهم — ولو الرد مرجّعهمش بتتستخدم القيمة
  /// المبعوتة وتاريخ النهارده.
  Future<ApiResult<BookingHistoryModel>> saveBookingRating({
    required BookingHistoryModel booking,
    required int stars,
  }) async {
    try {
      final response = await _onlineDoctorServices.saveBookingRating(
        booking.bookingId,
        {"value": stars},
      );
      final data = response is Map ? response['data'] : null;
      final value = data is Map ? data['value'] : null;
      final date = data is Map ? data['date'] : null;
      return ApiResult.success(
        booking.copyWith(
          userRating: value is num ? value.toDouble() : stars.toDouble(),
          userRatingDate: (date is String ? DateTime.tryParse(date) : null) ??
              DateTime.now(),
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// بيحفظ تعليق المريض على الطبيب (أول مرة أو تعديل) وبيرجّع الموعد
  /// بالتعليق وتاريخه زى ما الـ API بيأكدهم — ولو الرد مرجّعهمش بيتستخدم
  /// النص المبعوت وتاريخ النهارده.
  Future<ApiResult<BookingHistoryModel>> saveBookingComment({
    required BookingHistoryModel booking,
    required String text,
  }) async {
    try {
      final response = await _onlineDoctorServices.saveBookingComment(
        booking.bookingId,
        {"text": text},
      );
      final data = response is Map ? response['data'] : null;
      final savedText = data is Map ? data['text'] : null;
      final date = data is Map ? data['date'] : null;
      return ApiResult.success(
        booking.copyWith(
          userComment: savedText is String ? savedText : text,
          userCommentDate: (date is String ? DateTime.tryParse(date) : null) ??
              DateTime.now(),
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<AppointmentRoomModel>> getAppointmentRoom({
    required String bookingId,
  }) async {
    try {
      final response =
          await _onlineDoctorServices.getAppointmentRoom(bookingId);
      return ApiResult.success(
        AppointmentRoomModel.fromJson(response['data'] as Map<String, dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// اجتماع الفيديو بتاع الموعد — `null` لو الطبيب لسه منشأهوش (`404`).
  Future<ApiResult<VideoMeetingModel?>> getVideoMeeting({
    required String appointmentId,
  }) async {
    try {
      final response =
          await _onlineDoctorServices.getVideoMeeting(appointmentId);
      return ApiResult.success(
        VideoMeetingModel.fromJson(response['data'] as Map<String, dynamic>),
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const ApiResult.success(null);
      }
      return ApiResult.failure(ApiErrorHandler.handle(error));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// بيضيف سؤال للطبيب على الموعد وبيرجّعه بالـ `questionId` بتاعه.
  Future<ApiResult<RoomQuestionModel>> addBookingQuestion({
    required String bookingId,
    required String text,
  }) async {
    try {
      final response = await _onlineDoctorServices.addBookingQuestion(
        bookingId,
        {"text": text},
      );
      return ApiResult.success(_questionFromResponse(response, text: text));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// بيغيّر نص [question] وبيرجّعه بعد التعديل زى ما الـ API بيأكده.
  Future<ApiResult<RoomQuestionModel>> editBookingQuestion({
    required String bookingId,
    required RoomQuestionModel question,
    required String text,
  }) async {
    try {
      final response = await _onlineDoctorServices.editBookingQuestion(
        bookingId,
        question.questionId,
        {"text": text},
      );
      return ApiResult.success(
        _questionFromResponse(
          response,
          text: text,
          questionId: question.questionId,
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> deleteBookingQuestion({
    required String bookingId,
    required String questionId,
  }) async {
    try {
      await _onlineDoctorServices.deleteBookingQuestion(bookingId, questionId);
      return const ApiResult.success(true);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// بيضيف [user] كمشارك فى محادثة الموعد وبيرجّعه بالـ `participantId`
  /// بتاعه — الـ Backend هو اللى بيبعتله إشعار الإضافة.
  Future<ApiResult<RoomParticipantModel>> addBookingParticipant({
    required String bookingId,
    required SearchPhoneNumberUser user,
    required String relation,
  }) async {
    try {
      final response = await _onlineDoctorServices.addBookingParticipant(
        bookingId,
        {"userId": user.userId, "relation": relation},
      );
      final data = response is Map ? response['data'] : null;
      final sent = RoomParticipantModel(
        userId: user.userId.toString(),
        name: user.fullName,
        relation: relation,
        imageUrl: user.profileImage,
      );
      if (data is! Map<String, dynamic>) return ApiResult.success(sent);
      // أى حقل الرد مرجّعهوش بياخد القيمة المبعوتة.
      final saved = RoomParticipantModel.fromJson(data);
      return ApiResult.success(
        RoomParticipantModel(
          participantId: saved.participantId,
          userId: saved.userId.isEmpty ? sent.userId : saved.userId,
          name: saved.name.isEmpty ? sent.name : saved.name,
          relation: saved.relation.isEmpty ? sent.relation : saved.relation,
          imageUrl: saved.imageUrl ?? sent.imageUrl,
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> removeBookingParticipant({
    required String bookingId,
    required String participantId,
  }) async {
    try {
      await _onlineDoctorServices.removeBookingParticipant(
        bookingId,
        participantId,
      );
      return const ApiResult.success(true);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// السؤال من `data` فى رد الإضافة/التعديل — وأى حقل الرد مرجّعهوش بياخد
  /// القيمة المبعوتة.
  RoomQuestionModel _questionFromResponse(
    dynamic response, {
    required String text,
    String questionId = '',
  }) {
    final data = response is Map ? response['data'] : null;
    final savedId = data is Map ? data['questionId']?.toString() : null;
    final savedText = data is Map ? data['text'] : null;
    return RoomQuestionModel(
      questionId: savedId == null || savedId.isEmpty ? questionId : savedId,
      text: savedText is String && savedText.isNotEmpty ? savedText : text,
    );
  }
}
