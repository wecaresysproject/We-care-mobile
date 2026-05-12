import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/networking/models/update_fcm_token_request_body.dart';
import 'package:we_care/features/create_new_password/data/models/create_new_password_request_body.dart';
import 'package:we_care/features/create_new_password/data/models/create_new_password_response_model.dart';
import 'package:we_care/features/forget_password/Data/models/forget_password_request_body_model.dart';
import 'package:we_care/features/forget_password/Data/models/forget_password_response_model.dart';
import 'package:we_care/features/login/Data/models/login_request_body_model.dart';
import 'package:we_care/features/login/Data/models/login_response_model.dart';
import 'package:we_care/features/otp/data/models/resend_otp_request_body.dart';
import 'package:we_care/features/otp/data/models/resend_otp_response_model.dart';
import 'package:we_care/features/otp/data/models/verify_otp_request_body_model.dart';
import 'package:we_care/features/otp/data/models/verify_otp_response_model.dart';
import 'package:we_care/features/sign_up/Data/models/sign_up_request_body_model.dart';
import 'package:we_care/features/sign_up/Data/models/sign_up_response_model.dart';

import 'auth_api_constants.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: AuthApiConstants.baseUrl)
abstract class AuthApiServices {
  factory AuthApiServices(Dio dio, {String? baseUrl}) = _AuthApiServices;
  @POST(AuthApiConstants.signUpEndPoint)
  Future<SignUpResponseModel> signup(
    @Body() SignUpRequestBodyModel signupRequestBody,
  );

  @POST(AuthApiConstants.verifyOtpEndPoint)
  Future<VerifyOtpResponseModel> verifyOtp(
    @Body() VerifyOtpRequestBodyModel verifyOtpRequestBody,
  );
  @POST(AuthApiConstants.loginEndPoint)
  Future<LoginResponseModel> login(
    @Body() LoginRequestBodyModel loginRequestBody,
  );

  @POST(AuthApiConstants.resendOtpEndPoint)
  Future<ResendOtpResponseModel> resendOtp(
    @Body() ResendOtpRequestBody resendOtpRequestBody,
  );

  @PUT(AuthApiConstants.createNewPasswordEndPoint)
  Future<CreateNewPasswordResponseModel> createNewPassword(
    @Body() CreateNewPasswordRequestBody createNewPasswordRequestBody,
  );

  @POST(AuthApiConstants.forgotPasswordEndPoint)
  Future<ForgetPasswordResponseModel> forgetPassword(
    @Body() ForgetPasswordRequestBodyModel forgetPasswordRequestBody,
  );

  @POST("http://147.93.57.70/api/Statistics/fcm-token")
  Future<dynamic> updateFcmToken(
    @Body() UpdateFcmTokenRequestBody body,
  );

  @GET("http://147.93.57.70/api/DoctorUser/disclaimers/all")
  Future<dynamic> getTermsAndConditions(
    @Query("language") String language,
    @Query("userType") String userType,
  );
}
