import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_constants.dart';

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
  @GET(GeneticDiseasesConstants.getAllGeneticDiseasesClassfications)
  Future<dynamic> getAllGeneticDiseasesClassfications(
    @Query("language") String language,
  );
  @GET(GeneticDiseasesConstants.getAllGeneticDiseasesStatus)
  Future<dynamic> getAllGeneticDiseasesStatus(
    @Query("language") String language,
  );
  @GET(GeneticDiseasesConstants.getGeneticDiseasesBasedOnClassification)
  Future<dynamic> getGeneticDiseasesBasedOnClassification(
    @Query("language") String language,
    @Query("medicalClassification") String medicalClassification,
  );
}
