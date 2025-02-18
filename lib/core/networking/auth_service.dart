import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/otp/Data/models/resend_otp_request_body.dart';
import 'package:we_care/features/otp/Data/models/resend_otp_response_model.dart';

import '../../features/login/Data/models/login_request_body_model.dart';
import '../../features/login/Data/models/login_response_model.dart';
import '../../features/otp/Data/models/verify_otp_request_body_model.dart';
import '../../features/otp/Data/models/verify_otp_response_model.dart';
import '../../features/sign_up/Data/models/sign_up_request_body_model.dart';
import '../../features/sign_up/Data/models/sign_up_response_model.dart';
import 'auth_api_constants.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: AuthApiConstants.baseUrl)
abstract class AuthApiServices {
  factory AuthApiServices(Dio dio) = _AuthApiServices;

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
    @Body() ResendOtpRequestBody signupRequestBody,
  );
}
