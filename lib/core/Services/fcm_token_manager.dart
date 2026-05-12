import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/networking/auth_service.dart';
import 'package:we_care/core/networking/models/update_fcm_token_request_body.dart';

/// Manages FCM token lifecycle: fetching, caching, syncing with backend,
/// and listening for token refresh events.
///
/// Usage:
/// - Call [syncFcmToken] after login or on app startup if user is logged in.
/// - Call [startTokenRefreshListener] to listen for token refresh events.
/// - Call [clearCachedToken] on logout to clean up cached token.
class FcmTokenManager {
  FcmTokenManager(this._authApiServices);

  final AuthApiServices _authApiServices;

  static const String _cachedTokenKey = 'last_sent_fcm_token';

  /// Debounce timer to prevent rapid-fire duplicate token syncs.
  Timer? _debounceTimer;

  /// Subscription for token refresh events.
  StreamSubscription<String>? _tokenRefreshSubscription;

  /// Main sync method:
  /// 1. Gets current FCM token from Firebase
  /// 2. Compares with cached token
  /// 3. Sends to backend only if changed
  /// 4. Updates cache on success
  Future<void> syncFcmToken() async {
    try {
      final String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null || fcmToken.isEmpty) {
        AppLogger.warning('FcmTokenManager: Failed to get FCM token');
        return;
      }

      AppLogger.info('FcmTokenManager: FCM token fetched');

      final String cachedToken =
          await CacheHelper.getSecuredString(_cachedTokenKey);

      if (fcmToken == cachedToken) {
        AppLogger.info('FcmTokenManager: Token unchanged, skipping sync');
        return;
      }

      final bool success = await _sendTokenToServer(fcmToken);

      if (success) {
        await CacheHelper.setSecuredString(_cachedTokenKey, fcmToken);
        AppLogger.logMessage("FCM Token: $fcmToken");

        AppLogger.info('FcmTokenManager: Token synced and cached successfully');
      }
    } catch (e) {
      AppLogger.error('FcmTokenManager: Error syncing FCM token: $e');
    }
  }

  /// Starts listening for FCM token refresh events.
  /// When a new token is received, it syncs with backend (debounced).
  void startTokenRefreshListener() {
    // Cancel any existing subscription to avoid duplicates
    _tokenRefreshSubscription?.cancel();

    _tokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen(
      (String newToken) {
        AppLogger.info('FcmTokenManager: Token refresh detected');
        _debouncedSync(newToken);
      },
      onError: (error) {
        AppLogger.error(
            'FcmTokenManager: Error listening for token refresh: $error');
      },
    );

    AppLogger.info('FcmTokenManager: Token refresh listener started');
  }

  /// Sends FCM token to backend via the auth API service.
  /// Returns `true` on success, `false` on failure.
  Future<bool> _sendTokenToServer(String token) async {
    try {
      await _authApiServices.updateFcmToken(
        UpdateFcmTokenRequestBody(userFcmToken: token),
      );
      AppLogger.info('FcmTokenManager: Token sent to server successfully');
      return true;
    } catch (e) {
      AppLogger.error('FcmTokenManager: Failed to send token to server: $e');
      return false;
    }
  }

  /// Debounces rapid token refresh events to avoid duplicate API calls.
  void _debouncedSync(String token) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () async {
      final String cachedToken =
          await CacheHelper.getSecuredString(_cachedTokenKey);

      if (token == cachedToken) {
        AppLogger.info(
            'FcmTokenManager: Debounced token unchanged, skipping sync');
        return;
      }

      final bool success = await _sendTokenToServer(token);
      if (success) {
        await CacheHelper.setSecuredString(_cachedTokenKey, token);
        AppLogger.info(
            'FcmTokenManager: Refreshed token synced and cached successfully');
      }
    });
  }

  /// Clears cached FCM token from local storage.
  /// Call this on user logout.
  Future<void> clearCachedToken() async {
    await CacheHelper.removeSecuredString(_cachedTokenKey);
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _debounceTimer?.cancel();
    _debounceTimer = null;
    AppLogger.info(
        'FcmTokenManager: Cached token cleared and listeners stopped');
  }

  Future<String> getAndLogToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    AppLogger.info('FCM Token: $token');
    return token ?? '';
  }
}
