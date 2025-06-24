import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_care/features/Biometrics/biometrics_data_entry/logic/cubit/biometrics_data_entry_cubit.dart';
import 'package:we_care/features/Biometrics/biometrics_services.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_cubit.dart';
import 'package:we_care/features/Biometrics/data/repos/biometrics_data_entry_repo.dart';
import 'package:we_care/features/Biometrics/data/repos/biometrics_view_repo.dart';
import 'package:we_care/features/dental_module/data/repos/dental_data_entry_repo.dart';
import 'package:we_care/features/dental_module/data/repos/dental_repo.dart';
import 'package:we_care/features/dental_module/dental_data_entry_view/logic/cubit/dental_data_entry_cubit.dart';
import 'package:we_care/features/dental_module/dental_services.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_cubit.dart';
import 'package:we_care/features/emergency_complaints/data/repos/emergency_complaints_data_entry_repo.dart';
import 'package:we_care/features/emergency_complaints/data/repos/emergency_complaints_view_repo.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaint_details_cubit.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaints_data_entry_cubit.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_services.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/logic/emergency_complaints_view_cubit.dart';
import 'package:we_care/features/eyes/data/repos/eyes_data_entry_repo.dart';
import 'package:we_care/features/eyes/data/repos/glasses_data_entry_repo.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/eyes_data_entry_cubit.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/glasses_data_entry_cubit.dart';
import 'package:we_care/features/eyes/eyes_services.dart';
import 'package:we_care/features/genetic_diseases/data/repos/genetic_diseases_data_entry_repo.dart';
import 'package:we_care/features/genetic_diseases/data/repos/genetic_diseases_view_repo.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/create_new_gentic_disease_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_services.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_cubit.dart';
import 'package:we_care/features/medicine/data/repos/medicine_data_entry_repo.dart';
import 'package:we_care/features/medicine/data/repos/medicine_view_repo.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medication_symptoms_form_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicine_scanner_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_services.dart';
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_cubit.dart';
import 'package:we_care/features/prescription/data/repos/prescription_data_entry_repo.dart';
import 'package:we_care/features/prescription/data/repos/prescription_view_repo.dart';
import 'package:we_care/features/prescription/prescription_data_entry/logic/cubit/prescription_data_entry_cubit.dart';
import 'package:we_care/features/prescription/prescription_services.dart';
import 'package:we_care/features/show_data_entry_types/Data/Repository/categories_repo.dart';
import 'package:we_care/features/show_data_entry_types/Data/Service/categories_services.dart';
import 'package:we_care/features/surgeries/data/repos/surgeries_data_entry_repo.dart';
import 'package:we_care/features/surgeries/data/repos/surgeries_repo.dart';
import 'package:we_care/features/surgeries/surgeries_data_entry_view/logic/cubit/surgery_data_entry_cubit.dart';
import 'package:we_care/features/surgeries/surgeries_services.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_cubit.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_cubit.dart';
import 'package:we_care/features/test_laboratory/data/repos/test_analysis_data_entry_repo.dart';
import 'package:we_care/features/test_laboratory/data/repos/test_analysis_view_repo.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/logic/cubit/test_analysis_data_entry_cubit.dart';
import 'package:we_care/features/test_laboratory/test_analysis_services.dart';
import 'package:we_care/features/vaccine/data/repos/vaccine_data_entry_repo.dart';
import 'package:we_care/features/vaccine/data/repos/vaccine_view_repo.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/logic/cubit/vaccine_data_entry_cubit.dart';
import 'package:we_care/features/vaccine/vaccine_services.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccine_view_cubit.dart';
import 'package:we_care/features/x_ray/data/repos/x_ray_data_entry_repo.dart';
import 'package:we_care/features/x_ray/data/repos/x_ray_view_repo.dart';
import 'package:we_care/features/x_ray/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_cubit.dart';
import 'package:we_care/features/x_ray/xray_services.dart';

import '../../features/create_new_password/Data/repo/create_new_password_repo.dart';
import '../../features/create_new_password/Presentation/view_models/cubit/create_new_password_cubit.dart';
import '../../features/forget_password/Data/Repostory/forget_password_repo.dart';
import '../../features/forget_password/Presentation/view_models/cubit/forget_password_cubit.dart';
import '../../features/login/Data/Repostory/login_repo.dart';
import '../../features/login/logic/cubit/login_cubit.dart';
import '../../features/otp/Data/repo/otp_repository.dart';
import '../../features/otp/logic/otp_cubit.dart';
import '../../features/sign_up/Data/repos/sign_up_repo.dart';
import '../../features/sign_up/logic/sign_up_cubit.dart';
import '../global/Helpers/image_quality_detector.dart';
import '../networking/auth_service.dart';
import '../networking/dio_serices.dart';

final getIt = GetIt.instance;
Future<void> setUpDependencyInjection() async {
  // getIt.registerSingleton<HiveServices>(
  //   await HiveServices.create(),
  // ); //! recheck this later

  setupAppServices();
  setupAppRepos();
  setupAppCubits();
}

void setupAppCubits() {
  getIt.registerFactory<SignUpCubit>(
    () => SignUpCubit(
      getIt<SignUpRepo>(),
    ),
  );
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      getIt<LoginRepo>(),
    ),
  );
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(
      getIt<ForgetPasswordRepo>(),
    ),
  );
  getIt.registerFactory<CreateNewPasswordCubit>(
    () => CreateNewPasswordCubit(
      getIt<CreateNewPasswordRepo>(),
    ),
  );
  getIt.registerFactory<XRayDataEntryCubit>(
    () => XRayDataEntryCubit(
      getIt<XRayDataEntryRepo>(),
    ),
  );

  getIt.registerFactory<OtpCubit>(
    () => OtpCubit(
      getIt<OtpRepository>(),
    ),
  );

  getIt.registerFactory<PrescriptionDataEntryCubit>(
    () => PrescriptionDataEntryCubit(
      getIt<PrescriptionDataEntryRepo>(),
    ),
  );

  getIt.registerFactory<XRayViewCubit>(
    () => XRayViewCubit(getIt<XRayViewRepo>()),
  );
  getIt.registerFactory<SurgeryDataEntryCubit>(
    () => SurgeryDataEntryCubit(
      getIt<SurgeriesDataEntryRepo>(),
    ),
  );
  getIt.registerFactory<TestAnalysisDataEntryCubit>(
    () => TestAnalysisDataEntryCubit(
      getIt<TestAnalysisDataEntryRepo>(),
    ),
  );

  getIt.registerFactory<TestAnalysisViewCubit>(
    () => TestAnalysisViewCubit(
      getIt<TestAnalysisViewRepo>(),
    ),
  );

  getIt.registerFactory<VaccineDataEntryCubit>(
    () => VaccineDataEntryCubit(
      getIt<VaccineDataEntryRepo>(),
    ),
  );

  getIt.registerFactory<PrescriptionViewCubit>(
    () => PrescriptionViewCubit(
      getIt<PrescriptionViewRepo>(),
    ),
  );
  getIt.registerFactory<EmergencyComplaintsDataEntryCubit>(
    () => EmergencyComplaintsDataEntryCubit(
      getIt<EmergencyComplaintsDataEntryRepo>(),
    ),
  );
  getIt.registerFactory<EmergencyComplaintsViewCubit>(
    () => EmergencyComplaintsViewCubit(
      getIt<EmergencyComplaintsViewRepo>(),
    ),
  );

  getIt.registerFactory<EmergencyComplaintDataEntryDetailsCubit>(
    () => EmergencyComplaintDataEntryDetailsCubit(
      getIt<EmergencyComplaintsDataEntryRepo>(),
    ),
  );

  getIt.registerFactory<VaccineViewCubit>(
    () => VaccineViewCubit(
      getIt<VaccineViewRepo>(),
    ),
  );
  getIt.registerFactory<MedicinesDataEntryCubit>(
    () => MedicinesDataEntryCubit(
      getIt<MedicinesDataEntryRepo>(),
    ),
  );
  getIt.registerFactory(
    () => SurgeriesViewCubit(
      getIt<SurgeriesViewRepo>(),
    ),
  );
  getIt.registerFactory<MedicationSymptomsFormCubit>(
    () => MedicationSymptomsFormCubit(
      getIt<MedicinesDataEntryRepo>(),
    ),
  );

  getIt.registerFactory<MedicineViewCubit>(
    () => MedicineViewCubit(
      getIt<MedicinesViewRepo>(),
    ),
  );
  getIt.registerFactory<MedicineScannerCubit>(
    () => MedicineScannerCubit(
      getIt<MedicinesDataEntryRepo>(),
    ),
  );
  getIt.registerFactory<DentalDataEntryCubit>(
    () => DentalDataEntryCubit(
      getIt<DentalDataEntryRepo>(),
    ),
  );

  getIt.registerFactory<DentalViewCubit>(
    () => DentalViewCubit(
      dentalRepository: getIt<DentalRepo>(),
    ),
  );
  getIt.registerFactory<GeneticDiseasesDataEntryCubit>(
    () => GeneticDiseasesDataEntryCubit(
      getIt<GeneticDiseasesDataEntryRepo>(),
    ),
  );
  getIt.registerFactory<CreateNewGenticDiseaseCubit>(
    () => CreateNewGenticDiseaseCubit(
      getIt<GeneticDiseasesDataEntryRepo>(),
    ),
  );

  getIt.registerFactory<GeneticsDiseasesViewCubit>(
    () => GeneticsDiseasesViewCubit(
      geneticDiseasesViewRepo: getIt<GeneticDiseasesViewRepo>(),
    ),
  );
  getIt.registerFactory<BiometricsDataEntryCubit>(
    () => BiometricsDataEntryCubit(
      getIt<BiometricsDataEntryRepo>(),
    ),
  );

  getIt.registerFactory<BiometricsViewCubit>(
    () => BiometricsViewCubit(
      getIt<BiometricsViewRepo>(),
    ),
  );
  getIt.registerFactory<EyesDataEntryCubit>(
    () => EyesDataEntryCubit(
      getIt<EyesDataEntryRepo>(),
    ),
  );
  getIt.registerFactory<GlassesDataEntryCubit>(
    () => GlassesDataEntryCubit(
      getIt<GlassesDataEntryRepo>(),
    ),
  );
}

void setupAppRepos() {
  getIt.registerLazySingleton<SignUpRepo>(
    () => SignUpRepo(
      getIt<AuthApiServices>(),
    ),
  );

  getIt.registerLazySingleton<OtpRepository>(
    () => OtpRepository(
      getIt<AuthApiServices>(),
    ),
  );
  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepo(
      getIt<AuthApiServices>(),
    ),
  );
  getIt.registerLazySingleton<ForgetPasswordRepo>(
    () => ForgetPasswordRepo(
      getIt<AuthApiServices>(),
    ),
  );

  getIt.registerLazySingleton<CreateNewPasswordRepo>(
    () => CreateNewPasswordRepo(
      getIt<AuthApiServices>(),
    ),
  );

  getIt.registerLazySingleton<XRayViewRepo>(
    () => XRayViewRepo(
      getIt<XRayApiServices>(),
    ),
  );
  getIt.registerLazySingleton<XRayDataEntryRepo>(
    () => XRayDataEntryRepo(
      getIt<XRayApiServices>(),
    ),
  );
  getIt.registerLazySingleton<TestAnalysisDataEntryRepo>(
    () => TestAnalysisDataEntryRepo(
      getIt<TestAnalysisSerices>(),
    ),
  );
  getIt.registerLazySingleton<TestAnalysisViewRepo>(
    () => TestAnalysisViewRepo(
      getIt<TestAnalysisSerices>(),
    ),
  );

  getIt.registerLazySingleton<PrescriptionDataEntryRepo>(
    () => PrescriptionDataEntryRepo(
      getIt<PrescriptionServices>(),
    ),
  );
  getIt.registerLazySingleton<VaccineDataEntryRepo>(
    () => VaccineDataEntryRepo(
      vaccineApiServices: getIt<VaccineApiServices>(),
    ),
  );

  getIt.registerLazySingleton<PrescriptionViewRepo>(
    () => PrescriptionViewRepo(
      prescriptionServices: getIt<PrescriptionServices>(),
    ),
  );
  getIt.registerLazySingleton<EmergencyComplaintsDataEntryRepo>(
    () => EmergencyComplaintsDataEntryRepo(
      getIt<EmergencyComplaintsServices>(),
    ),
  );

  getIt.registerLazySingleton<EmergencyComplaintsViewRepo>(
    () => EmergencyComplaintsViewRepo(
      getIt<EmergencyComplaintsServices>(),
    ),
  );

  getIt.registerLazySingleton<VaccineViewRepo>(
    () => VaccineViewRepo(
      getIt<VaccineApiServices>(),
    ),
  );
  getIt.registerLazySingleton<MedicinesDataEntryRepo>(
    () => MedicinesDataEntryRepo(
      getIt<MedicinesServices>(),
    ),
  );

  getIt.registerLazySingleton<SurgeriesViewRepo>(
    () => SurgeriesViewRepo(
      surgeriesService: getIt<SurgeriesService>(),
    ),
  );
  getIt.registerLazySingleton<SurgeriesDataEntryRepo>(
      () => SurgeriesDataEntryRepo(
            surgeriesService: getIt<SurgeriesService>(),
          ));

  getIt.registerLazySingleton<MedicinesViewRepo>(
    () => MedicinesViewRepo(
      getIt<MedicinesServices>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CategoriesRepository(
      getIt<CategoriesServices>(),
    ),
  );
  getIt.registerLazySingleton(
    () => DentalDataEntryRepo(
      dentalService: getIt<DentalService>(),
    ),
  );

  getIt.registerLazySingleton(
    () => DentalRepo(
      dentalService: getIt<DentalService>(),
    ),
  );
  getIt.registerLazySingleton<GeneticDiseasesDataEntryRepo>(
    () => GeneticDiseasesDataEntryRepo(
      getIt<GeneticDiseasesServices>(),
    ),
  );
  getIt.registerLazySingleton<GeneticDiseasesViewRepo>(
    () => GeneticDiseasesViewRepo(
      getIt<GeneticDiseasesServices>(),
    ),
  );
  getIt.registerLazySingleton<BiometricsDataEntryRepo>(
    () => BiometricsDataEntryRepo(
      getIt<BiometricsServices>(),
    ),
  );

  getIt.registerLazySingleton<BiometricsViewRepo>(
    () => BiometricsViewRepo(
      biometricsServices: getIt<BiometricsServices>(),
    ),
  );
  getIt.registerLazySingleton<EyesDataEntryRepo>(
    () => EyesDataEntryRepo(
      eyesService: getIt<EyesModuleServices>(),
    ),
  );
  getIt.registerLazySingleton<GlassesDataEntryRepo>(
    () => GlassesDataEntryRepo(
      eyesModuleServices: getIt<EyesModuleServices>(),
    ),
  );
}

void setupAppServices() {
  Dio dio = DioServices.getDio();
  getIt.registerLazySingleton<AuthApiServices>(() => AuthApiServices(dio));
  getIt.registerLazySingleton<ImagePicker>(
    () => ImagePicker(),
  );
  getIt.registerLazySingleton<AudioPlayer>(() => AudioPlayer());

  getIt.registerLazySingleton<ImagePickerService>(
    () => ImagePickerService(),
  );

  getIt.registerLazySingleton<XRayApiServices>(
    () => XRayApiServices(dio),
  );
  getIt.registerLazySingleton<TestAnalysisSerices>(
    () => TestAnalysisSerices(dio),
  );

  getIt.registerLazySingleton<PrescriptionServices>(
    () => PrescriptionServices(dio),
  );
  getIt.registerLazySingleton<VaccineApiServices>(
    () => VaccineApiServices(dio),
  );
  getIt.registerLazySingleton<EmergencyComplaintsServices>(
    () => EmergencyComplaintsServices(dio),
  );
  getIt.registerLazySingleton<MedicinesServices>(
    () => MedicinesServices(dio),
  );
  getIt.registerLazySingleton<SurgeriesService>(
    () => SurgeriesService(dio),
  );
  getIt.registerLazySingleton<CategoriesServices>(
    () => CategoriesServices(dio),
  );
  getIt.registerLazySingleton<DentalService>(
    () => DentalService(dio),
  );
  getIt.registerLazySingleton<GeneticDiseasesServices>(
    () => GeneticDiseasesServices(dio),
  );
  getIt.registerLazySingleton<BiometricsServices>(
    () => BiometricsServices(dio),
  );
  getIt.registerLazySingleton<EyesModuleServices>(
    () => EyesModuleServices(dio),
  );
}
