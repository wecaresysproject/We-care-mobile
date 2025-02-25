import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/x_ray/xray_api_constants.dart';

part 'xray_services.g.dart';

@RestApi(baseUrl: XrayApiConstants.baseUrl)
abstract class XRayApiServices {
  factory XRayApiServices(Dio dio, {String? baseUrl}) = _XRayApiServices;
}
