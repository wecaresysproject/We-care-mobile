import 'dart:convert';

import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/core/networking/auth_service.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_bookings_stats_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_latest_comments_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_monthly_examinations_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_performance_stats_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_profile_summary_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_ratings_summary_model.dart';

/// Doctor home screen — one call per section (see docs/api/doctor_home_api.md
/// and docs/api/doctor_home_ads_comments_ratings_api.md)
/// so each section loads and fails on its own.
class DoctorHomeRepo {
  final AuthApiServices _authApiServices;
  final DoctorServices _doctorServices;

  DoctorHomeRepo(this._authApiServices, this._doctorServices);

  /// Fetches the header data and refreshes the on-device copy on success.
  Future<ApiResult<DoctorProfileSummaryModel>> getProfileSummary() async {
    try {
      final response = await _doctorServices.getHomeProfileSummary();
      final profile = DoctorProfileSummaryModel.fromJson(_data(response));
      await CacheHelper.setData(
        AppStrings.doctorProfileSummaryCacheKey,
        jsonEncode(profile.toJson()),
      );
      return ApiResult.success(profile);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// The header data saved by the last successful [getProfileSummary], or
  /// `null` when there is none (first launch, or after logout cleared it).
  Future<DoctorProfileSummaryModel?> getCachedProfileSummary() async {
    try {
      final String cached =
          await CacheHelper.getString(AppStrings.doctorProfileSummaryCacheKey);
      if (cached.isEmpty) return null;
      return DoctorProfileSummaryModel.fromJson(
        jsonDecode(cached) as Map<String, dynamic>,
      );
    } catch (error) {
      AppLogger.debug('DoctorHomeRepo: unreadable cached profile — $error');
      return null;
    }
  }

  Future<ApiResult<DoctorBookingsStatsModel>> getBookingsStats() async {
    try {
      final response = await _doctorServices.getHomeBookingsStats();
      return ApiResult.success(
        DoctorBookingsStatsModel.fromJson(_data(response)),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<DoctorMonthlyExaminationsModel>>
      getMonthlyExaminations() async {
    try {
      final response = await _doctorServices.getHomeMonthlyExaminations();
      return ApiResult.success(
        DoctorMonthlyExaminationsModel.fromJson(_data(response)),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<DoctorPerformanceStatsModel>> getPerformanceStats() async {
    try {
      final response = await _doctorServices.getHomePerformanceStats();
      return ApiResult.success(
        DoctorPerformanceStatsModel.fromJson(_data(response)),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// `GET /Ad/doctor/all` — returns the ad image URLs.
  Future<ApiResult<List<String>>> getAds() async {
    try {
      final response = await _doctorServices.getHomeAds('Doctor', 'ar');
      final ads = List<String>.from(response['data'] ?? const [])
          .where((url) => url.trim().isNotEmpty)
          .toList();
      return ApiResult.success(ads);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<DoctorLatestCommentsModel>> getLatestComments() async {
    try {
      final response = await _doctorServices.getHomeLatestComments();
      return ApiResult.success(
        DoctorLatestCommentsModel.fromJson(_data(response)),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<DoctorRatingsSummaryModel>> getRatingsSummary() async {
    try {
      final response = await _doctorServices.getHomeRatingsSummary();
      return ApiResult.success(
        DoctorRatingsSummaryModel.fromJson(_data(response)),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<dynamic>> logout() async {
    try {
      final response = await _authApiServices.logout(
        currentUserType.name.firstLetterToUpperCase,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Map<String, dynamic> _data(dynamic response) =>
      response['data'] as Map<String, dynamic>;
}
