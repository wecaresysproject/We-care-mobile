import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_error_model.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/prescription/data/models/doctor_prescription_content_model.dart';
import 'package:we_care/features/doctor/prescription/data/models/previous_prescription_model.dart';

/// The booking's prescription: read it back, or upload its page images and
/// save it (docs/doctor_prescription_backend.md).
class DoctorPrescriptionRepo {
  DoctorPrescriptionRepo(this._doctorServices, this._sharedRepo);

  final DoctorServices _doctorServices;
  final AppSharedRepo _sharedRepo;

  /// The saved prescription, or null when nothing was saved yet.
  Future<ApiResult<SavedDoctorPrescriptionModel?>> getPrescription(
    String bookingId,
  ) async {
    try {
      final response = await _doctorServices.getBookingPrescription(bookingId);
      return ApiResult.success(_parseSaved(response));
    } catch (error) {
      return ApiResult.failure(_toError(error));
    }
  }

  /// "الروشتات القديمة" on the call screen: what this doctor wrote for the
  /// booking's patient in earlier bookings, newest first.
  Future<ApiResult<PreviousPrescriptionsModel>> getPreviousPrescriptions(
    String bookingId,
  ) =>
      _loadPrescriptions(
        () => _doctorServices.getPreviousPrescriptions(bookingId),
      );

  /// "ملفات المرضى القدامى" → "الروشتات": everything this doctor wrote for
  /// [patientId], newest first.
  Future<ApiResult<PreviousPrescriptionsModel>> getPatientPrescriptions(
    String patientId,
  ) =>
      _loadPrescriptions(
        () => _doctorServices.getPatientPrescriptions(patientId),
      );

  Future<ApiResult<PreviousPrescriptionsModel>> _loadPrescriptions(
    Future<dynamic> Function() request,
  ) async {
    try {
      final response = await request();
      final data = response is Map ? response['data'] : null;
      return ApiResult.success(
        PreviousPrescriptionsModel.fromJson(
          data is Map ? Map<String, dynamic>.from(data) : const {},
        ),
      );
    } catch (error) {
      return ApiResult.failure(_toError(error, readOnly: true));
    }
  }

  /// The doctor's full name and specialty for the prescription paper, from
  /// the doctor's saved profile. A part that can't be loaded is empty.
  Future<({String name, String specialty})> getDoctorInfo() async {
    Future<Map<dynamic, dynamic>> data(Future<dynamic> request) async {
      try {
        final response = await request;
        final value = response is Map ? response['data'] : null;
        return value is Map ? value : const {};
      } catch (_) {
        return const {};
      }
    }

    String joined(Iterable<Object?> parts, String separator) => parts
        .map((part) => part?.toString().trim() ?? '')
        .where((part) => part.isNotEmpty)
        .join(separator);

    final results = await Future.wait([
      data(_doctorServices.getBasicData()),
      data(_doctorServices.getMedicalSpecialty()),
    ]);
    final basic = results[0];
    final specialty = results[1];
    return (
      name: joined(
        [basic['firstName'], basic['fatherName'], basic['familyName']],
        ' ',
      ),
      specialty: joined(
        [specialty['mainSpecialty'], specialty['subSpecialty']],
        ' - ',
      ),
    );
  }

  /// Uploads [pageImages] (PNG, page order) all at once, then saves
  /// [content] with their URLs. Nothing is saved if any upload fails, so the
  /// data and the images never get out of sync.
  Future<ApiResult<SavedDoctorPrescriptionModel>> savePrescription({
    required String bookingId,
    required List<Uint8List> pageImages,
    required DoctorPrescriptionContentModel content,
  }) async {
    final List<String> imageUrls;
    try {
      imageUrls = await _uploadPages(pageImages);
    } on ApiErrorModel catch (error) {
      return ApiResult.failure(error);
    } catch (error) {
      return ApiResult.failure(_toError(error));
    }

    try {
      final response = await _doctorServices.saveBookingPrescription(
        bookingId,
        {'images': imageUrls, 'prescription': content.toJson()},
      );
      final saved = _parseSaved(response);
      return ApiResult.success(
        saved ??
            SavedDoctorPrescriptionModel(
              patientPrescriptionId: null,
              createdAt: null,
              editedAt: null,
              images: imageUrls,
              content: content,
            ),
      );
    } catch (error) {
      return ApiResult.failure(_toError(error));
    }
  }

  Future<List<String>> _uploadPages(List<Uint8List> pageImages) async {
    final directory = await getTemporaryDirectory();
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final files = <File>[];
    try {
      for (var i = 0; i < pageImages.length; i++) {
        final file = File(
          '${directory.path}/prescription_${stamp}_page${i + 1}.png',
        );
        await file.writeAsBytes(pageImages[i], flush: true);
        files.add(file);
      }

      final results = await Future.wait([
        for (final file in files)
          _sharedRepo.uploadImage(
            image: file,
            language: AppStrings.arabicLang,
            contentType: AppStrings.contentTypeMultiPartValue,
          ),
      ]);

      // Same order as the pages: page 1 first.
      return [
        for (final result in results)
          result.when(
            success: (response) {
              if (!response.isImageUploadedSuccessfully ||
                  response.imageUrl.isEmpty) {
                throw ApiErrorModel(errors: [_uploadFailedMessage]);
              }
              return response.imageUrl;
            },
            failure: (_) => throw ApiErrorModel(errors: [_uploadFailedMessage]),
          ),
      ];
    } finally {
      for (final file in files) {
        file.delete().ignore();
      }
    }
  }

  static const _uploadFailedMessage = 'تعذر رفع صور الروشتة، حاول مرة أخرى';

  static SavedDoctorPrescriptionModel? _parseSaved(dynamic response) {
    final data = response is Map ? response['data'] : null;
    if (data is! Map) return null;
    return SavedDoctorPrescriptionModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  /// The server answers 403 in English for an expired window or someone
  /// else's booking; show Arabic text instead.
  static ApiErrorModel _toError(Object error, {bool readOnly = false}) {
    if (error is DioException && error.response?.statusCode == 403) {
      final body = error.response?.data;
      final message = body is Map ? body['message']?.toString() ?? '' : '';
      final expired = message.toLowerCase().contains('expired') ||
          (body is Map && body['data'] is Map);
      return ApiErrorModel(
        success: false,
        errors: [
          expired
              ? readOnly
                  ? 'انتهت صلاحية الوصول لملف المريض'
                  : 'انتهت صلاحية الوصول لملف المريض، لا يمكن تعديل الروشتة'
              : 'غير مصرح لك بالوصول لملف هذا المريض',
        ],
      );
    }
    return ApiErrorHandler.handle(error);
  }
}
