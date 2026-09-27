import 'package:we_care/core/global/Helpers/app_enums.dart';

bool isLoggedInUser = false;

/// The account type chosen on the user-type screen. It picks the post-login
/// flow and is sent as the `userType` query parameter on every auth call.
/// Persisted next to the auth token (see `saveCurrentUserType`).
UserTypes currentUserType = UserTypes.patient;

class AuthApiConstants {
  static const userTokenKey = "userTokenKey";
  static const isUserLoggedIn = "isUserLoggedIn";
  static const userTypeKey = "userTypeKey";
  static const baseUrl = "http://147.93.57.70/api/v1/auth/";
  static const signUpEndPoint = "register";
  static const resendOtpEndPoint = "resend-otp";
  static const verifyOtpEndPoint = "verify-otp";
  static const loginEndPoint = "login";
  static const changePasswordEndPoint = "change-password";
  static const createNewPasswordEndPoint = "change-password";
  static const forgotPasswordEndPoint = "forgot-password";
  static const logoutEndPoint = "logout";
}
