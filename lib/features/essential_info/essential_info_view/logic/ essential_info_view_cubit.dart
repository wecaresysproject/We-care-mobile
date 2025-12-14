import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/essential_info/data/repos/essential_info_view_repo.dart';
import 'package:we_care/features/essential_info/essential_info_view/logic/essential_info_view_state.dart';

class EssentialInfoViewCubit extends Cubit<EssentialInfoViewState> {
  final EssentialInfoViewRepo _essentialInfoRepo;

  EssentialInfoViewCubit(this._essentialInfoRepo)
      : super(EssentialInfoViewState.initial());

  Future<void> init() async {
    await getUserEssentialInfo();
    await calculateCompletionPercentage();
  }

  Future<void> getUserEssentialInfo() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _essentialInfoRepo.getUserEssentialInfo(
      language: AppStrings.arabicLang,
      userType: 'Patient',
    );

    result.when(
      success: (response) {
        CacheHelper.setData("userName", response.data?.fullName ?? "");
        CacheHelper.setData("userPhoto", response.data?.personalPhotoUrl ?? "");
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            userEssentialInfo: response.data,
            responseMessage: response.message,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            responseMessage: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> deleteEssentialInfo() async {
    emit(state.copyWith(deleteRequestStatus: RequestStatus.loading));
    final result = await _essentialInfoRepo.deleteEssentialInfo(
      language: AppStrings.arabicLang,
      userType: 'Patient',
      docId: state.userEssentialInfo!.docId!,
    );
    result.when(
      success: (response) {
        emit(state.copyWith(
          deleteRequestStatus: RequestStatus.success,
          responseMessage: response,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          deleteRequestStatus: RequestStatus.failure,
          responseMessage: error.errors.first,
        ));
      },
    );
  }

  Future<void> shareEssentialInfoDetails() async {
    final info = state.userEssentialInfo!;
    final tempDir = await getTemporaryDirectory();

    // ✅ تحميل الصور (إن وُجدت)
    final personalPhotoPath =
        info.personalPhotoUrl != null && info.personalPhotoUrl!.isNotEmpty
            ? await downloadImage(
                info.personalPhotoUrl!, tempDir, 'personal_photo.jpg')
            : null;

    final insuranceCardPath = info.insuranceCardPhotoUrl != null &&
            info.insuranceCardPhotoUrl!.isNotEmpty
        ? await downloadImage(
            info.insuranceCardPhotoUrl!, tempDir, 'insurance_card.jpg')
        : null;

    // ✅ النص الذي سيتم مشاركته
    final shareText = '''
🩺 بياناتي الأساسية:
---------------------
👤 الاسم: ${info.fullName ?? '-'}
🪪 الرقم الوطني: ${info.nationalID ?? '-'}
📧 البريد الإلكتروني: ${info.email ?? '-'}
📷 صورة شخصية: ${info.personalPhotoUrl != null ? 'مرفقة أدناه 📎' : '-'}
🔎 تفاصيل الإعاقة: ${info.disabilityDetails ?? '-'}
👤 الحالة الاجتماعية: ${info.socialStatus ?? '-'}
👶 عدد الأبناء: ${info.numberOfChildren ?? '-'}
🌍 الدولة: ${info.country ?? '-'}
🏙️ المدينة: ${info.city ?? '-'}
📞 هاتف الطوارئ 1: ${info.emergencyContact1 ?? '-'}
📞 هاتف الطوارئ 2: ${info.emergencyContact2 ?? '-'}
❤️ فصيلة الدم: ${info.bloodType ?? '-'}
🏢 شركة التأمين: ${info.insuranceCompany ?? '-'}
📅 تاريخ انتهاء التأمين: ${info.insuranceCoverageExpiryDate ?? '-'}
📝 شروط التأمين: ${info.additionalTerms ?? '-'}
📷 صورة التأمين: ${info.insuranceCardPhotoUrl != null ? 'مرفقة أدناه 📎' : '-'}

📌 الحي: ${info.areaOrDistrict ?? '-'}
👨‍⚕️ طبيب العائلة: ${info.familyDoctorName ?? '-'}
📞 هاتف الطبيب: ${info.familyDoctorPhoneNumber ?? '-'}
🔎 نوع الإعاقة: ${info.disabilityType ?? '-'}
---------------------
تمت المشاركة من تطبيق WeCare 💙
''';

    // ✅ تحضير قائمة الصور المرفقة
    final imagePaths = [
      if (personalPhotoPath != null) personalPhotoPath,
      if (insuranceCardPath != null) insuranceCardPath,
    ];

// ✅ مشاركة النص + الصور
    if (imagePaths.isNotEmpty) {
      // نحول المسارات إلى XFile objects
      final xFiles = imagePaths.map((path) => XFile(path)).toList();
      await Share.shareXFiles(xFiles, text: shareText);
    } else {
      await Share.share(shareText);
    }
  }

  Future<void> calculateCompletionPercentage() async {
    double percentage = 0.0;

    final info = state.userEssentialInfo;
    if (info == null) return;

    if (info.fullName != null &&
        info.fullName!.isNotEmpty &&
        info.fullName!.isFilled) {
      percentage += 12;
    }
    if (info.dateOfBirth != null &&
        info.dateOfBirth!.isNotEmpty &&
        info.dateOfBirth!.isFilled) {
      percentage += 12;
    }
    if (info.gender != null &&
        info.gender!.isNotEmpty &&
        info.gender!.isFilled) {
      percentage += 12;
    }
    if (info.nationalID != null &&
        info.nationalID!.isNotEmpty &&
        info.nationalID!.isFilled) {
      percentage += 12;
    }
    if (info.email != null &&
        info.email!.isNotEmpty &&
        info.email!.isFilled) {
      percentage += 3;
    }
    if (info.personalPhotoUrl != null &&
        info.personalPhotoUrl!.isNotEmpty &&
        info.personalPhotoUrl!.isFilled) {
      percentage += 12;
    }
    if (info.country != null &&
        info.country!.isNotEmpty &&
        info.country!.isFilled) {
      percentage += 12;
    }
    if (info.city != null && info.city!.isNotEmpty && info.city!.isFilled) {
      percentage += 6;
    }
    if (info.areaOrDistrict != null &&
        info.areaOrDistrict!.isNotEmpty &&
        info.areaOrDistrict!.isFilled) {
      percentage += 2; // District
    }
    // Neighborhood (3%) - Missing in model, skipping
    if (info.bloodType != null &&
        info.bloodType!.isNotEmpty &&
        info.bloodType!.isFilled) {
      percentage += 6;
    }
    if (info.insuranceCompany != null &&
        info.insuranceCompany!.isNotEmpty &&
        info.insuranceCompany!.isFilled) {
      percentage += 3;
    }
    if (info.disabilityType != null &&
        info.disabilityType!.isNotEmpty &&
        info.disabilityType!.isFilled) {
      percentage += 3;
    }
    if (info.socialStatus != null &&
        info.socialStatus!.isNotEmpty &&
        info.socialStatus!.isFilled) {
      percentage += 3;
    }
    if (info.numberOfChildren != null) percentage += 3;
    if (info.familyDoctorName != null &&
        info.familyDoctorName!.isNotEmpty &&
        info.familyDoctorName!.isFilled) {
      percentage += 1;
    }
    if (info.familyDoctorPhoneNumber != null &&
        info.familyDoctorPhoneNumber!.isNotEmpty &&
        info.familyDoctorPhoneNumber!.isFilled) {
      percentage += 3;
    }
    if (info.workHours != null &&
        info.workHours!.isNotEmpty &&
        info.workHours!.isFilled) {
      percentage += 3;
    }
    if (info.emergencyContact1 != null &&
        info.emergencyContact1!.isNotEmpty &&
        info.emergencyContact1!.isFilled) {
      percentage += 1;
    }
    if (info.emergencyContact2 != null &&
        info.emergencyContact2!.isNotEmpty &&
        info.emergencyContact2!.isFilled) {
      percentage += 1;
    }

    emit(state.copyWith(profileCompletionPercentage: percentage));
  }
}
