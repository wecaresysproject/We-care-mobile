// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AuthApiServices implements AuthApiServices {
  _AuthApiServices(this._dio, {this.baseUrl}) {
    baseUrl ??= AuthApiConstants.baseUrl;
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<SignUpResponseModel> signup(
      SignUpRequestBodyModel signupRequestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(signupRequestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SignUpResponseModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, AuthApiConstants.signUpEndPoint,
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SignUpResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp(
      VerifyOtpRequestBodyModel verifyOtpRequestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(verifyOtpRequestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VerifyOtpResponseModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, AuthApiConstants.verifyOtpEndPoint,
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VerifyOtpResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LoginResponseModel> login(
      LoginRequestBodyModel loginRequestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(loginRequestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LoginResponseModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, AuthApiConstants.loginEndPoint,
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LoginResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ResendOtpResponseModel> resendOtp(
      ResendOtpRequestBody resendOtpRequestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(resendOtpRequestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ResendOtpResponseModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, AuthApiConstants.resendOtpEndPoint,
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ResendOtpResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CreateNewPasswordResponseModel> createNewPassword(
      CreateNewPasswordRequestBody createNewPasswordRequestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createNewPasswordRequestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CreateNewPasswordResponseModel>(
            Options(method: 'PUT', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, AuthApiConstants.createNewPasswordEndPoint,
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CreateNewPasswordResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ForgetPasswordResponseModel> forgetPassword(
      ForgetPasswordRequestBodyModel forgetPasswordRequestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(forgetPasswordRequestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ForgetPasswordResponseModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, AuthApiConstants.forgotPasswordEndPoint,
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ForgetPasswordResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<dynamic> getTermsAndConditions(
    String language,
    String userType,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'language': language,
      r'userType': userType,
    };
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'http://147.93.57.70/api/DoctorUser/disclaimers/all',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      requestOptions.responseType = ResponseType.json;
    }
    return requestOptions;
  }
}
