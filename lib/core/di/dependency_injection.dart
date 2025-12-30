import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_care/core/Services/push_notifications_services.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/core/global/shared_services.dart';
import 'package:we_care/features/Biometrics/biometrics_data_entry/logic/cubit/biometrics_data_entry_cubit.dart';
import 'package:we_care/features/Biometrics/biometrics_services.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_cubit.dart';
import 'package:we_care/features/Biometrics/data/repos/biometrics_data_entry_repo.dart';
import 'package:we_care/features/Biometrics/data/repos/biometrics_view_repo.dart';
import 'package:we_care/features/allergy/allergy_data_entry_view/logic/cubit/allergy_data_entry_cubit.dart';
import 'package:we_care/features/allergy/allergy_services.dart';
import 'package:we_care/features/allergy/allergy_view/logic/allergy_view_cubit.dart';
import 'package:we_care/features/allergy/data/repos/allergy_data_entry_repo.dart';
import 'package:we_care/features/allergy/data/repos/allergy_view_repo.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_data_entry/logic/cubit/chronic_disease_data_entry_cubit.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_services.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_view/logic/chronic_disease_view_cubit.dart';
import 'package:we_care/features/chronic_disease/data/repos/chronic_disease_data_entry_repo.dart';
import 'package:we_care/features/chronic_disease/data/repos/chronic_disease_view_repo.dart';
import 'package:we_care/features/contact_support/data/repos/contact_support_repository.dart';
import 'package:we_care/features/contact_support/logic/contact_support_cubit.dart';
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
import 'package:we_care/features/essential_info/data/repos/essential_info_data_entry_repo.dart';
import 'package:we_care/features/essential_info/data/repos/essential_info_view_repo.dart';
import 'package:we_care/features/essential_info/essential_info_data_entry/logic/cubit/essential_data_entry_cubit.dart';
import 'package:we_care/features/essential_info/essential_info_services.dart';
import 'package:we_care/features/essential_info/essential_info_view/logic/%20essential_info_view_cubit.dart';
import 'package:we_care/features/eyes/data/repos/eyes_data_entry_repo.dart';
import 'package:we_care/features/eyes/data/repos/eyes_view_repo.dart';
import 'package:we_care/features/eyes/data/repos/glasses_data_entry_repo.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/eyes_data_entry_cubit.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/glasses_data_entry_cubit.dart';
import 'package:we_care/features/eyes/eyes_services.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_cubit.dart';
import 'package:we_care/features/genetic_diseases/data/repos/genetic_diseases_data_entry_repo.dart';
import 'package:we_care/features/genetic_diseases/data/repos/genetic_diseases_view_repo.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/create_new_gentic_disease_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_services.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_cubit.dart';
import 'package:we_care/features/home_tab/cubits/home/home_cubit.dart';
import 'package:we_care/features/home_tab/repositories/home_repository.dart';
import 'package:we_care/features/home_tab/services/home_service.dart';
import 'package:we_care/features/medical_illnesses/data/repos/mental_illnesses_data_entry_repo.dart';
import 'package:we_care/features/medical_illnesses/data/repos/mental_illnesses_view_repo.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/logic/cubit/mental_illnesses_data_entry_cubit.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_cubit.dart';
import 'package:we_care/features/medical_illnesses/mental_illnesses_services.dart';
import 'package:we_care/features/medical_notes/data/repos/medical_notes_repository.dart';
import 'package:we_care/features/medical_notes/logic/medical_notes_cubit.dart';
import 'package:we_care/features/medical_notes/medical_notes_services.dart';
import 'package:we_care/features/medicine/data/repos/medicine_data_entry_repo.dart';
import 'package:we_care/features/medicine/data/repos/medicine_view_repo.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medication_symptoms_form_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicine_scanner_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_services.dart';
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';
import 'package:we_care/features/nutration/data/repos/nutration_view_repo.dart';
import 'package:we_care/features/nutration/nutration_services.dart';
import 'package:we_care/features/nutration/nutration_view/logic/nutration_view_cubit.dart';
import 'package:we_care/features/physical_activaty/data/repos/physical_activaty_data_entry_repo.dart';
import 'package:we_care/features/physical_activaty/data/repos/physical_activaty_view_repo.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_data_entry/logic/cubit/physical_activaty_data_entry_cubit.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_services.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_view/logic/physical_activaty_view_cubit.dart';
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_cubit.dart';
import 'package:we_care/features/prescription/data/repos/prescription_data_entry_repo.dart';
import 'package:we_care/features/prescription/data/repos/prescription_view_repo.dart';
import 'package:we_care/features/prescription/prescription_data_entry/logic/cubit/prescription_data_entry_cubit.dart';
import 'package:we_care/features/prescription/prescription_services.dart';
import 'package:we_care/features/show_data_entry_types/Data/Repository/categories_repo.dart';
import 'package:we_care/features/show_data_entry_types/Data/Service/categories_services.dart';
import 'package:we_care/features/supplements/data/repos/supplements_view_repo.dart';
import 'package:we_care/features/supplements/supplements_services.dart';
import 'package:we_care/features/supplements/supplements_view/logic/supplements_view_cubit.dart';
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
      getIt<AppSharedRepo>(),
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
      getIt<AppSharedRepo>(),
    ),
  );

  getIt.registerFactory<XRayViewCubit>(
    () => XRayViewCubit(getIt<XRayViewRepo>()),
  );
  getIt.registerFactory<SurgeryDataEntryCubit>(
    () => SurgeryDataEntryCubit(
      getIt<SurgeriesDataEntryRepo>(),
      getIt<AppSharedRepo>(),
    ),
  );
  getIt.registerFactory<TestAnalysisDataEntryCubit>(
    () => TestAnalysisDataEntryCubit(
      getIt<TestAnalysisDataEntryRepo>(),
      getIt<AppSharedRepo>(),
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
      getIt<AppSharedRepo>(),
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
      getIt<AppSharedRepo>(),
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
      getIt<AppSharedRepo>(),
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
      getIt<AppSharedRepo>(),
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
      getIt<AppSharedRepo>(),
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
      getIt<AppSharedRepo>(),
    ),
  );
  getIt.registerFactory<GlassesDataEntryCubit>(() => GlassesDataEntryCubit(
        getIt<GlassesDataEntryRepo>(),
        getIt<AppSharedRepo>(),
      ));

  getIt.registerFactory<EyeViewCubit>(
    () => EyeViewCubit(
      getIt<EyesViewRepo>(),
    ),
  );
  getIt.registerFactory<MedicalIllnessesDataEntryCubit>(
    () => MedicalIllnessesDataEntryCubit(
      getIt<MentalIllnessesDataEntryRepo>(),
      getIt<PushNotificationsService>(),
      getIt<AppSharedRepo>(),
    ),
  );
  getIt.registerFactory<MentalIllnessDataViewCubit>(
    () => MentalIllnessDataViewCubit(
      getIt<MentalIllnessesViewRepo>(),
    ),
  );
  getIt.registerFactory<ChronicDiseaseDataEntryCubit>(
    () => ChronicDiseaseDataEntryCubit(
      getIt<ChronicDiseaseDataEntryRepo>(),
      getIt<AppSharedRepo>(),
    ),
  );
  getIt.registerFactory<ChronicDiseaseViewCubit>(
    () => ChronicDiseaseViewCubit(
      getIt<ChronicDiseaseViewRepo>(),
    ),
  );
  getIt.registerFactory<AllergyDataEntryCubit>(
    () => AllergyDataEntryCubit(
      getIt<AllergyDataEntryRepo>(),
      getIt<AppSharedRepo>(),
    ),
  );
  getIt.registerFactory<AllergyViewCubit>(
    () => AllergyViewCubit(
      getIt<AllergyViewRepo>(),
    ),
  );
  getIt.registerFactory<NutrationViewCubit>(
    () => NutrationViewCubit(
      getIt<NutrationViewRepo>(),
    ),
  );
  getIt.registerFactory<PhysicalActivatyDataEntryCubit>(
    () => PhysicalActivatyDataEntryCubit(
      getIt<PhysicalActivatyDataEntryRepo>(),
    ),
  );
  getIt.registerFactory<PhysicalActivityViewCubit>(
    () => PhysicalActivityViewCubit(
      getIt<PhysicalActivatyViewRepo>(),
    ),
  );
  getIt.registerFactory<EssentialInfoViewCubit>(
    () => EssentialInfoViewCubit(
      getIt<EssentialInfoViewRepo>(),
    ),
  );

  getIt.registerFactory<EssentialDataEntryCubit>(
    () => EssentialDataEntryCubit(
      getIt<AppSharedRepo>(),
      getIt<EssentialInfoDataEntryRepo>(),
    ),
  );

  getIt.registerFactory<MedicalNotesCubit>(
    () => MedicalNotesCubit(
      getIt<MedicalNotesRepository>(),
    ),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      getIt<HomeRepository>(),
    ),
  );
  getIt.registerFactory<ContactSupportCubit>(
    () => ContactSupportCubit(
      getIt<ContactSupportRepository>(),
    ),
  );
  getIt.registerFactory<SupplementsViewCubit>(
    () => SupplementsViewCubit(
      getIt<SupplementsViewRepo>(),
    ),
  );
}

void setupAppRepos() {
  getIt.registerLazySingleton<SignUpRepo>(
    () => SignUpRepo(
      getIt<AuthApiServices>(),
    ),
  );
  getIt.registerLazySingleton<AppSharedRepo>(
    () => AppSharedRepo(
      getIt<SharedServices>(),
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
      getIt<SurgeriesService>(),
    ),
  );

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

  getIt.registerLazySingleton<EyesViewRepo>(() => EyesViewRepo(
        eyesService: getIt<EyesModuleServices>(),
      ));
  getIt.registerLazySingleton<MentalIllnessesDataEntryRepo>(
    () => MentalIllnessesDataEntryRepo(
      illnessesServices: getIt<MentalIllnessesServices>(),
    ),
  );
  getIt.registerLazySingleton<MentalIllnessesViewRepo>(
    () => MentalIllnessesViewRepo(
      mentalIllnessesServices: getIt<MentalIllnessesServices>(),
    ),
  );
  getIt.registerLazySingleton<ChronicDiseaseDataEntryRepo>(
    () => ChronicDiseaseDataEntryRepo(
      getIt<ChronicDiseaseServices>(),
    ),
  );
  getIt.registerLazySingleton<ChronicDiseaseViewRepo>(
    () => ChronicDiseaseViewRepo(
      diseaseServices: getIt<ChronicDiseaseServices>(),
    ),
  );
  getIt.registerLazySingleton<AllergyDataEntryRepo>(
    () => AllergyDataEntryRepo(
      allergyServices: getIt<AllergyServices>(),
    ),
  );
  getIt.registerLazySingleton<AllergyViewRepo>(
    () => AllergyViewRepo(
      allergyServices: getIt<AllergyServices>(),
    ),
  );
  getIt.registerLazySingleton<NutrationDataEntryRepo>(
    () => NutrationDataEntryRepo(
      getIt<NutrationServices>(),
    ),
  );
  getIt.registerLazySingleton<NutrationViewRepo>(
    () => NutrationViewRepo(
      nutrationServices: getIt<NutrationServices>(),
    ),
  );
  getIt.registerLazySingleton<PhysicalActivatyDataEntryRepo>(
    () => PhysicalActivatyDataEntryRepo(
      getIt<PhysicalActivityServices>(),
    ),
  );
  getIt.registerLazySingleton<PhysicalActivatyViewRepo>(
    () => PhysicalActivatyViewRepo(
      physicalActivityServices: getIt<PhysicalActivityServices>(),
    ),
  );

  getIt.registerLazySingleton<EssentialInfoViewRepo>(
    () => EssentialInfoViewRepo(
      essentialInfoServices: getIt<EssentialInfoServices>(),
    ),
  );
  getIt.registerLazySingleton<EssentialInfoDataEntryRepo>(
    () => EssentialInfoDataEntryRepo(
      getIt<EssentialInfoServices>(),
      getIt<SharedServices>(),
    ),
  );

  getIt.registerLazySingleton<MedicalNotesRepository>(
    () => MedicalNotesRepository(
      medicalNotesServices: getIt<MedicalNotesServices>(),
    ),
  );

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepository(
      getIt<HomeService>(),
    ),
  );
  getIt.registerLazySingleton<ContactSupportRepository>(
    () => ContactSupportRepository(),
  );
  getIt.registerLazySingleton<SupplementsViewRepo>(
    () => SupplementsViewRepo(
      services: getIt<SupplementsServices>(),
    ),
  );
}

void setupAppServices() {
  Dio dio = DioServices.getDio();
  getIt.registerLazySingleton<SharedServices>(
    () => SharedServices(
      dio,
    ),
  );
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
  getIt.registerLazySingleton<MentalIllnessesServices>(
    () => MentalIllnessesServices(dio),
  );
  getIt.registerLazySingleton<ChronicDiseaseServices>(
    () => ChronicDiseaseServices(dio),
  );
  getIt.registerLazySingleton<PushNotificationsService>(
    () => PushNotificationsService(),
  );
  getIt.registerLazySingleton<AllergyServices>(
    () => AllergyServices(
      dio,
    ),
  );
  getIt.registerLazySingleton<NutrationServices>(
    () => NutrationServices(
      dio,
    ),
  );
  getIt.registerLazySingleton<PhysicalActivityServices>(
    () => PhysicalActivityServices(
      dio,
    ),
  );

  getIt.registerLazySingleton<EssentialInfoServices>(
    () => EssentialInfoServices(
      dio,
    ),
  );

  getIt.registerLazySingleton<HomeService>(
    () => HomeService(dio),
  );
  getIt.registerLazySingleton<MedicalNotesServices>(
    () => MedicalNotesServices(dio),
  );
  getIt.registerLazySingleton<SupplementsServices>(
    () => SupplementsServices(dio),
  );
}
