import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/features/sign_up/Data/models/sign_up_request_body_model.dart';
import 'package:we_care/features/sign_up/Data/models/sign_up_response_model.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: AuthApiConstants.baseUrl)
abstract class AuthApiServices {
  factory AuthApiServices(Dio dio) = _AuthApiServices;

  @POST(AuthApiConstants.signUpEndPoint)
  Future<SignUpResponseModel> signup(
    @Body() SignUpRequestBodyModel signupRequestBody,
  );
}
