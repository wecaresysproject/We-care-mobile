import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_constants.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/data/models/medicine_data_entry_request_body.dart';

part 'genetic_diseases_services.g.dart';

@RestApi(baseUrl: GeneticDiseasesConstants.baseUrl)
abstract class GeneticDiseasesServices {
  factory GeneticDiseasesServices(Dio dio, {String? baseUrl}) =
      _GeneticDiseasesServices;

  @GET(GeneticDiseasesConstants.getAllCountries)
  Future<dynamic> getCountries(
    @Query('language') String language,
  );
  @GET(GeneticDiseasesConstants.getAllDoctors)
  Future<dynamic> getAllDoctors(
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
}
