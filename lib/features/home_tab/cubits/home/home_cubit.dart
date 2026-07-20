import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/Services/fcm_token_manager.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/core/networking/dio_serices.dart';
import 'package:we_care/features/home_tab/repositories/home_repository.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  final AppSharedRepo _appSharedRepo;
  final FcmTokenManager _fcmTokenManager;

  HomeCubit(this._homeRepository, this._appSharedRepo, this._fcmTokenManager)
      : super(HomeState.initial());

  Future<void> initialRequests() async {
    await Future.wait([
      getMessageNotifications(),
      getAds(),
    ]);
  }

  Future<void> getMessageNotifications() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _homeRepository.getMessageNotifications();

    result.when(
      success: (notifications) {
        emit(state.copyWith(
          notifications: notifications,
          requestStatus: RequestStatus.success,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          errorMessage: error.errors.isNotEmpty
              ? error.errors.first
              : 'Failed to load notifications',
        ));
      },
    );
  }

  Future<void> getModulesGuidanceVideos() async {
    emit(state.copyWith(videoRequestStatus: RequestStatus.loading));

    final result = await _appSharedRepo.getModulesGuidanceVideos();

    result.when(
      success: (videos) {
        emit(state.copyWith(
          videos: videos,
          videoRequestStatus: RequestStatus.success,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          videoRequestStatus: RequestStatus.failure,
          errorMessage: error.errors.isNotEmpty
              ? error.errors.first
              : 'Failed to load videos',
        ));
      },
    );
  }

  Future<void> getAds() async {
    emit(state.copyWith(adsRequestStatus: RequestStatus.loading));

    final result = await _homeRepository.getAds();

    result.when(
      success: (ads) {
        AppLogger.info('xxxxxxx getAds success $ads');
        emit(
          state.copyWith(
            ads: ads,
            adsRequestStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        AppLogger.info('xxxxxxx getAds failure $error');
        emit(
          state.copyWith(
            adsRequestStatus: RequestStatus.failure,
            errorMessage: error.errors.isNotEmpty
                ? error.errors.first
                : 'فشل في تحميل الإعلانات',
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(logoutRequestStatus: RequestStatus.loading));

    final result = await _homeRepository.logout();

    result.when(
      success: (_) async {
        // 1. Clear all secure storage (auth token + FCM cached token)
        await CacheHelper.clearAllSecuredData();

        // 2. Clear SharedPreferences (user flags / preferences)
        await CacheHelper.clearAllData();

        // 3. Remove Authorization header from live Dio instance
        DioServices.clearAuthToken();

        // 4. Stop FCM token refresh listener
        await _fcmTokenManager.clearCachedToken();

        AppLogger.info('HomeCubit: Logout cleanup completed successfully');
        emit(state.copyWith(logoutRequestStatus: RequestStatus.success));
      },
      failure: (error) {
        emit(state.copyWith(
          logoutRequestStatus: RequestStatus.failure,
          errorMessage:
              error.errors.isNotEmpty ? error.errors.first : 'Failed to logout',
        ));
      },
    );
  }
}
