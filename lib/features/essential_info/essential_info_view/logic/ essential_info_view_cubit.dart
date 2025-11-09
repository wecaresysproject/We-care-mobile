import 'package:bloc/bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/essential_info/data/repos/essential_info_view_repo.dart';
import 'package:we_care/features/essential_info/essential_info_view/logic/essential_info_view_state.dart';

class EssentialInfoViewCubit extends Cubit<EssentialInfoViewState> {
  final EssentialInfoViewRepo _essentialInfoRepo;

  EssentialInfoViewCubit(this._essentialInfoRepo)
      : super(EssentialInfoViewState.initial());

  Future<void> getUserEssentialInfo() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _essentialInfoRepo.getUserEssentialInfo(
      language: AppStrings.arabicLang,
      userType: 'Patient',
    );

    result.when(
      success: (response) {
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
    final shareText = '''
🩺 بياناتي الأساسية:
---------------------
👤 الاسم: ${info.fullName ?? '-'}
🪪 الرقم الوطني: ${info.nationalID ?? '-'}
📧 البريد الإلكتروني: ${info.email ?? '-'}
🌍 الدولة: ${info.country ?? '-'}
🏙️ المدينة: ${info.city ?? '-'}
📞 هاتف الطوارئ 1: ${info.emergencyContact1 ?? '-'}
📞 هاتف الطوارئ 2: ${info.emergencyContact2 ?? '-'}
❤️ فصيلة الدم: ${info.bloodType ?? '-'}
🏢 شركة التأمين: ${info.insuranceCompany ?? '-'}
---------------------
تمت المشاركة من تطبيق WeCare 💙
''';

    await Share.share(shareText);
  }
}
