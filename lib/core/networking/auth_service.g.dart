// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// ***************************************************************************
// RetrofitGenerator
// ***************************************************************************

class _AuthApiServices implements AuthApiServices {
  _AuthApiServices(this._dio, {this.baseUrl}) {
    baseUrl ??= AuthApiConstants.baseUrl;
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<SignUpResponseModel> signup(
      SignUpRequestBodyModel signupRequestBody) async {
    final response = await _dio.post(
      AuthApiConstants.signUpEndPoint,
      data: signupRequestBody.toJson(),
    );
    return SignUpResponseModel.fromJson(response.data);
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp(
      VerifyOtpRequestBodyModel verifyOtpRequestBody) async {
    final response = await _dio.post(
      AuthApiConstants.verifyOtpEndPoint,
      data: verifyOtpRequestBody.toJson(),
    );
    return VerifyOtpResponseModel.fromJson(response.data);
  }

  @override
  Future<LoginResponseModel> login(
      LoginRequestBodyModel loginRequestBody) async {
    final response = await _dio.post(
      AuthApiConstants.loginEndPoint,
      data: loginRequestBody.toJson(),
    );
    return LoginResponseModel.fromJson(response.data);
  }

  @override
  Future<ResendOtpResponseModel> resendOtp(
      ResendOtpRequestBody resendOtpRequestBody) async {
    final response = await _dio.post(
      AuthApiConstants.resendOtpEndPoint,
      data: resendOtpRequestBody.toJson(),
    );
    return ResendOtpResponseModel.fromJson(response.data);
  }

  @override
  Future<CreateNewPasswordResponseModel> createNewPassword(
      CreateNewPasswordRequestBody createNewPasswordRequestBody) async {
    final response = await _dio.put(
      AuthApiConstants.createNewPasswordEndPoint,
      data: createNewPasswordRequestBody.toJson(),
    );
    return CreateNewPasswordResponseModel.fromJson(response.data);
  }

  @override
  Future<ForgetPasswordResponseModel> forgetPassword(
      ForgetPasswordRequestBodyModel forgetPasswordRequestBody) async {
    final response = await _dio.post(
      AuthApiConstants.forgotPasswordEndPoint,
      data: forgetPasswordRequestBody.toJson(),
    );
    return ForgetPasswordResponseModel.fromJson(response.data);
  }
}
