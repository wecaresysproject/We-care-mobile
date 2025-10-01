import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/features/Biometrics/biometrics_data_entry/Presentation/views/biometrics_data_entry_view.dart';
import 'package:we_care/features/Biometrics/biometrics_view/Presention/biometrics_view.dart';
import 'package:we_care/features/allergy/allergy_data_entry_view/Presentation/views/allergy_data_entry_view.dart';
import 'package:we_care/features/allergy/allergy_view/views/allergy_details_view.dart';
import 'package:we_care/features/allergy/allergy_view/views/allergy_view.dart';
import 'package:we_care/features/allergy/data/models/allergy_details_data_model.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_data_entry/Presentation/views/add_new_medicine_view.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_data_entry/Presentation/views/chronic_disease_data_entry_view.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_view/views/chronic_disease_details_view.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_view/views/chronic_disease_view.dart';
import 'package:we_care/features/chronic_disease/data/models/add_new_medicine_model.dart';
import 'package:we_care/features/chronic_disease/data/models/post_chronic_disease_model.dart';
import 'package:we_care/features/dental_module/dental_data_entry_view/Presentation/views/dental_anatomy_diagram_entry_view.dart';
import 'package:we_care/features/dental_module/dental_data_entry_view/Presentation/views/dental_data_entry_view.dart';
import 'package:we_care/features/dental_module/dental_view/views/tooth_anatomy_view.dart';
import 'package:we_care/features/emergency_complaints/data/models/get_single_complaint_response_model.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/Presentation/views/create_new_complaint_details_data_entry_view.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/Presentation/views/emergency_complaints_data_entry_view.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/views/emergency_complaints_view.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_details_model.dart';
import 'package:we_care/features/eyes/data/models/eye_procedures_and_symptoms_details_model.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/eye_data_entry.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/eye_procedures_and_syptoms_data_entry.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/glasses_information_category_data_entry_view.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/eye_or_galsses_view.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/eyes_data_entry_cubit.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/eyes_or_glasses_data_view.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/glasses_records_view.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatics_diseases_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/new_genetic_disease_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_detaills.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/Presentation/family_tree_view_from_data_entry.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/Presentation/views/create_new_genetic_disease_view.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/Presentation/views/family_memeber_genetic_disease_data_entry_view.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/Presentation/views/personal_genetic_disease_data_entry_view.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/genetic_diseaese_main_view.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/number_of_family_members_data_entry_view.dart.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/presentation/views/current_personal_genetic_disease_details_view.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/presentation/views/expected_personal_genatic_diseases_details_view.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/presentation/views/family_member_genatic_disease_details_view.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/presentation/views/family_member_genetic_diesases.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/presentation/views/family_tree_view.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/presentation/views/genetic_diseases_homw_screen.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/presentation/views/personal_genatic_diseases_screen.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/disable_we_care_mental_health_umbrella_view.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/enable_we_care_mental_health_umbrella_view.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/medical_illnesses_data_entry.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/mental_health_questionare_view.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/mental_ilness_choice_screen.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/logic/cubit/mental_illnesses_data_entry_cubit.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/Presentation/medical_illnesses_records_view.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/Presentation/mental_illness_answered_questions_view.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/Presentation/mental_illness_details_view.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/Presentation/mental_illness_follow_up_report_details_view.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/Presentation/mental_illness_follow_up_reports_data_view.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/Presentation/mental_illnesses_or_mind_umbrella_view.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/Presentation/umbrella_mental_ilnesss_records_view.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/medicine_view/Presention/medicine_view.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/screens/alarm_home_view.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/medicine_syptoms_details_view.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/medicines_data_entry_view.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/follow_up_nutration_plans_view.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/nutration_table_view.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/user_nutration_info_data_entry_view.dart';
import 'package:we_care/features/nutration/nutration_view/Presention/views/food_alternatives_view.dart';
import 'package:we_care/features/nutration/nutration_view/Presention/views/food_recomendation_view.dart';
import 'package:we_care/features/nutration/nutration_view/Presention/views/nutration_plan_data_view.dart';
import 'package:we_care/features/prescription/Presentation_view/views/prescription_details_view.dart';
import 'package:we_care/features/prescription/Presentation_view/views/prescription_view.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';
import 'package:we_care/features/prescription/prescription_data_entry/Presentation/views/prescription_data_entry_view.dart';
import 'package:we_care/features/show_data_entry_types/Presentation/views/medical_categories_types_view.dart';
import 'package:we_care/features/surgeries/data/models/get_user_surgeries_response_model.dart';
import 'package:we_care/features/surgeries/surgeries_data_entry_view/Presentation/views/surgeries_data_entry_view.dart';
import 'package:we_care/features/surgeries/surgeries_view/views/surgeries_view.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/analysis_view.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/Presentation/views/test_analysis_data_entry_view.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/Presentation/views/vaccine_data_entry_view.dart';
import 'package:we_care/features/vaccine/vaccine_view/Presention/vaccine_view.dart';
import 'package:we_care/features/x_ray/data/models/user_radiology_data_reponse_model.dart';
import 'package:we_care/features/x_ray/x_ray_data_entry/Presentation/views/x_ray_data_entry_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/x_ray_view.dart';

import '../../features/create_new_password/Presentation/views/create_new_password_view.dart';
import '../../features/forget_password/Presentation/views/forget_password_view.dart';
import '../../features/home_tab/Presentation/views/view_or_edit_medical_record_view.dart';
import '../../features/login/Presentation/views/login_view.dart';
import '../../features/otp/Presentation/views/otp_view.dart';
import '../../features/show_data_entry_types/Presentation/views/medical_categories_data_entry_types_view.dart';
import '../../features/sign_up/Presentation/views/sign_up_view.dart';
import '../../features/user_type/Presentation/views/user_type_view.dart';
import '../global/SharedWidgets/bottom_nav_bar.dart';
import '../global/app_strings.dart';
import 'routes.dart';

class AppRouter {
//automatically recalled when we use Navigator in our screen
  Route<dynamic>? onGenerateRoutes(RouteSettings route) {
    String routeName = route.name!;
    // ignore: unused_local_variable
    final arguments = route.arguments
        as dynamic; //!recheck as later , as it can be dynamic for most cases

    //! provide the nedded bloc providers here

    switch (routeName) {
      case Routes.userTypesView:
        return MaterialPageRoute(
          builder: (context) => const UserTypesView(),
        );
      case Routes.signUpView:
        return MaterialPageRoute(
          builder: (context) => const SignUpView(),
        );
      case Routes.loginView:
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );
      case Routes.forgetPasswordView:
        return MaterialPageRoute(
          builder: (context) => const ForgetPasswordView(),
        );
      case Routes.otpView:

        /// false by default => signUp => otp => home view
        return MaterialPageRoute(
          builder: (context) => OtpView(
            isForgetPasswordFlow:
                arguments?[AppStrings.isForgetPasswordFlowArgumentKey] ?? false,
            phoneNumber: arguments?[AppStrings.phoneNumberArgumentKey] ?? "+20",
          ),
        );
      case Routes.createNewPasswordView:
        return MaterialPageRoute(
          builder: (context) => CreateNewPasswordView(
            phoneNumber: arguments?[AppStrings.phoneNumberArgumentKey] ?? "+20",
          ),
        );
      case Routes.bottomNavBar:
        return MaterialPageRoute(
          builder: (context) => const CustomBottomNavBar(),
        );
      case Routes.viewOrEditMedicalRecord:
        return MaterialPageRoute(
          builder: (context) => const ViewOrEditMedicalRecord(),
        );
      case Routes.medicalDataEntryTypesView:
        return MaterialPageRoute(
          builder: (context) => MedicalDataEntryCategoryTypesView(),
        );
      case Routes.medicalCategoriesTypesView:
        return MaterialPageRoute(
          builder: (context) => MedicalCategoriesTypesView(),
        );
      case Routes.xrayCategoryDataEntryView:
        final xrayDetailsModel = arguments as RadiologyData?;
        return MaterialPageRoute(
          builder: (context) => XrayCategoryDataEntryView(
            editingXRayDetailsData: xrayDetailsModel,
          ),
        );
      case Routes.dentalAnatomyDiagramEntryView:
        return MaterialPageRoute(
          builder: (context) => DentalAnatomyDiagramEntryView(),
        );
      case Routes.toothAnatomyView:
        return MaterialPageRoute(
          builder: (context) => ToothAnatomyView(),
        );
      case Routes.prescriptionView:
        return MaterialPageRoute(
          builder: (context) => PrescriptionView(),
        );
      case Routes.prescriptionCategoryDataEntryView:
        final prescriptionDetailsModel = arguments
            as PrescriptionModel?; // Replace with your actual model type
        return MaterialPageRoute(
          builder: (context) => PrescriptionCategoryDataEntryView(
            editingPrescriptionDetailsData: prescriptionDetailsModel,
          ),
        );
      case Routes.prescriptionDetailsView:
        return MaterialPageRoute(
          builder: (context) => PrescriptionDetailsView(
            documentId: arguments?['id'] ?? "",
          ),
        );
      case Routes.medicalAnalysisView:
        return MaterialPageRoute(
          builder: (context) => MedicalAnalysisView(),
        );
      case Routes.testAnalsisDataEntryView:
        final testAnalysisDetails = arguments
            as AnalysisDetailedData?; // Replace with your actual model type

        return MaterialPageRoute(
          builder: (context) => TestAnalysisDataEntryView(
            editingAnalysisDetailsData: testAnalysisDetails,
          ),
        );

      case Routes.xRayDataView:
        return MaterialPageRoute(
          builder: (context) => const XRayView(),
        );
      case Routes.surgeriesView:
        return MaterialPageRoute(
          builder: (context) => const SurgeriesView(),
        );
      case Routes.surgeriesDataEntryView:
        final surgeryDetails = arguments as SurgeryModel?;
        return MaterialPageRoute(
          builder: (context) => SurgeriesDataEntryView(
            existingSurgeryModel: surgeryDetails,
          ),
        );
      case Routes.vaccineDataEntryView:
        final vaccineDetails = arguments as UserVaccineModel?;
        return MaterialPageRoute(
          builder: (context) => VaccineDataEntryView(
            editingVaccineData: vaccineDetails,
          ),
        );
      case Routes.vaccineView:
        return MaterialPageRoute(
          builder: (context) => VaccineView(),
        );
      case Routes.emergenciesComplaintDataEntryView:
        final complaintModelToBeEdited = arguments as DetailedComplaintModel?;

        return MaterialPageRoute(
          builder: (context) => EmergencyComplaintCategoryDataEntryView(
            complaint: complaintModelToBeEdited,
          ),
        );
      case Routes.addNewComplaintDetails:
        final complaintDetails = arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => CreateNewComplaintDetailsView(
            editingComplaintDetails: complaintDetails?['complaint'],
            complaintId: complaintDetails?['id'],
          ),
        );

      case Routes.familyMemberGeneticDiseaseDetailsView:
        final diseaseDetails = arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => FamilyMemberGeneticDiseaseDetailsView(
            disease: diseaseDetails?['disease'] ?? "",
            familyMemberCode: diseaseDetails?['familyMemberCode'] ?? "",
            familyMemberName: diseaseDetails?['familyMemberName'] ?? "",
          ),
        );
      case Routes.familyMemberGeneticDiseases:
        final memberDetails = arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => FamilyMemberGeneticDiseases(
            familyMemberCode: memberDetails?['familyMemberCode'] ?? "",
            familyMemberName: memberDetails?['familyMemberName'] ?? "",
          ),
        );
      case Routes.geneticDiseasesHomeScreen:
        return MaterialPageRoute(
          builder: (context) => const GeneticDiseasesHomeScreen(),
        );
      case Routes.personalGeneticDiseasesScreen:
        return MaterialPageRoute(
          builder: (context) => const PersonalGenaticDiseasesScreen(),
        );
      case Routes.personalGeneticDiseasesDetailsView:
        return MaterialPageRoute(
          builder: (context) => PersonalGenaticDiseasesDetailsView(
            disease: arguments,
          ),
        );

      case Routes.currentPersonalGeneticDiseasesDetailsView:
        return MaterialPageRoute(
          builder: (context) => CurrentPersonalGeneticDiseaseDetailsView(
            documentId: arguments,
          ),
        );

      case Routes.emergenciesComplaintDataView:
        return MaterialPageRoute(
          builder: (context) => const EmergencyComplaintsView(),
        );
      case Routes.medcinesView:
        return MaterialPageRoute(
          builder: (context) => MedicinesView(),
        );
      case Routes.medcinesDataEntryView:
        final medicineModel = arguments as MedicineModel?;
        return MaterialPageRoute(
          builder: (context) => MedicinesDataEntryView(
            medicineToEdit: medicineModel,
          ),
        );

      case Routes.medicationSymptomsFormFieldView:
        return MaterialPageRoute(
          builder: (context) => MedicineSyptomsDetailsView(
            //* null to path through getAllRequestsForAddingNewComplaintView flow
            editingComplaintDetails: null,
            complaintId: 2,
          ),
        );
      case Routes.dentalDataEntryView:
        final result = arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (context) => DentalDataEntryView(
            existingToothModel: result?['existingToothModel'],
            toothNumber: result?['toothNumber'],
            toothId: result?['teethDocumentId'] ?? "",
          ),
        );
      case Routes.alarmHomeView:
        return MaterialPageRoute(
          builder: (context) => AlarmHomeScreen(),
        );
      case Routes.personalGeneticDiseasesDataEnrtyView:
        final result = arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => PersonalGeneticDiseaseDataEntryView(
            personalGeneticDiseasesEditModel:
                result?['editModel'] as PersonalGeneticDiseasDetails?,
            editModelId: result?['editModelID'],
          ),
        );
      case Routes.numberOfFamilyMembersView:
        return MaterialPageRoute(
          builder: (context) => const NumberOfFamilyMembersView(),
        );
      case Routes.familyTreeViewFromDataEntry:
        return MaterialPageRoute(
          builder: (context) => const FamilyTreeViewFromDataEntry(),
        );
      case Routes.familyTreeScreen:
        return MaterialPageRoute(
          builder: (context) => const FamilyTreeView(),
        );
      case Routes.eyeDataEntry:
        final result = arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (context) => EyeDataEntry(
            selectedSyptoms: result?['selectedSymptoms'] ??
                [] as List<SymptomAndProcedureItem>,
            selectedProcedures: result?['selectedProcedures'] ??
                [] as List<SymptomAndProcedureItem>,
            affectedEyePart: result?['affectedEyePart'] as String,
            editModelId: result?['editModelId'] as String?,
            pastEyeData:
                result?['pastEyeData'] as EyeProceduresAndSymptomsDetailsModel?,
          ),
        );
      case Routes.eyeProceduresAndSyptomsDataEntry:
        final result = arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (context) => BlocProvider<EyesDataEntryCubit>(
            create: (context) => getIt.get<EyesDataEntryCubit>(),
            child: EyeProceduresAndSyptomsDataEntry(
              selectedEyePart: result?['eyePart'] as String,
            ),
          ),
        );
      case Routes.familyMemeberGeneticDiseaseDataEntryView:
        final result = arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => FamilyMemeberGeneticDiseaseDataEntryView(
            editModel: result?['familyMemberGeneticDiseases']
                as FamilyMemberGeneticsDiseasesResponseModel?,
            familyCodes: result!['memberCode'] as String,
            memberName: result['memberName'] as String,
          ),
        );
      case Routes.createNewGeneticDiseaseView:
        final argumentsMap = arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (context) => CreateNewGeneticDiseaseView(
            complaintId: argumentsMap?['id'] as int?,
            editingGeneticDiseaseDetails:
                argumentsMap?['geneticDisease'] as NewGeneticDiseaseModel?,
          ),
        );
      case Routes.geneticDiseaeseMainView:
        return MaterialPageRoute(
          builder: (context) => const GeneticDiseaeseMainView(),
        );
      case Routes.biometricsDataEntryView:
        return MaterialPageRoute(
          builder: (context) => const BiometricsDataEntryView(),
        );
      case Routes.biometricsView:
        return MaterialPageRoute(
          builder: (context) => const BiometricsView(), //!To be changed later
        );
      case Routes.eyeOrGlassesView:
        return MaterialPageRoute(
          builder: (context) => const EyeOrGlassesView(),
        );
      case Routes.eyesOrGlassesDataView:
        return MaterialPageRoute(
          builder: (context) => const EyesOrGlassesDataView(),
        );

      case Routes.glassesInformationView:
        return MaterialPageRoute(
            builder: (context) => const EyeGlassesRecordsView());
      case Routes.glassesInformationDataEntryView:
        final argumentsMap = arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (context) => GlassesInformationCategoryDataEntryView(
            glassesEditModel:
                argumentsMap?['glassesEditModel'] as EyeGlassesDetailsModel?,
            documentId: argumentsMap?['documentId'] as String?,
          ), //!To be changed later
        );
      case Routes.medicalIllnessOrMindUmbrellaView:
        return MaterialPageRoute(
          builder: (context) => const MedicalIllnessOrMindUmbrellaView(),
        );

      case Routes.mentalIllnessesRecordsView:
        return MaterialPageRoute(
          builder: (context) => const MentalIllnessRecordsView(),
        );
      case Routes.mentalIllnessesDataEntryView:
        return MaterialPageRoute(
          builder: (context) => const MentalIllnessDataEntry(),
        );
      case Routes.mentalIllnessChoiceScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<MedicalIllnessesDataEntryCubit>(
            create: (context) => getIt<MedicalIllnessesDataEntryCubit>(),
            child: const MentalIllnessChoiceScreen(),
          ),
        );
      case Routes.mentalIlnesssUmbrellaView:
        return MaterialPageRoute(
          builder: (context) => MentalIllnessesUmbrellRecordsView(),
        );
      case Routes.mentalIllnessFollowUpReports:
        return MaterialPageRoute(
          builder: (context) => MentalIllnessFollowUpReports(),
        );
      case Routes.mentalIllnessFollowUpReportDetailsView:
        final argumentsMap = arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (context) => MentalIllnessFollowUpReportDetailsView(
            docId: argumentsMap?['docId'],
          ), //MentalIllnessFollowUpReportDetailsView(),
        );
      case Routes.mentalUmbrellaHealthQuestionnairePage:
        final argumentsMap = arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (context) => BlocProvider<MedicalIllnessesDataEntryCubit>(
            create: (context) => getIt<MedicalIllnessesDataEntryCubit>(),
            child: MentalHealthQuestionnaireView(
              questions: argumentsMap?['questions'] as List<FcmQuestionModel>,
            ),
          ),
        );
      case Routes.mentalIllnessDocDetailsView:
        final argumentsMap = arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => MentalIllnessDetailsView(
            docId: argumentsMap['docId'],
          ),
        );
      case Routes.enableViewForWeCareMentalHealthUmbrella:
        return MaterialPageRoute(
            builder: (_) => EnableViewForWeCareMentalHealthUmbrella());
      case Routes.addNewMedicationView:
        final medicineDetails = arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider<MedicinesDataEntryCubit>(
            create: (context) =>
                getIt<MedicinesDataEntryCubit>()..initialDataEntryRequests(),
            child: AddNewMedicationView(
              medicineId: medicineDetails?['id'] as int?,
              editingMedicineDetailsData:
                  medicineDetails?['medicine'] as AddNewMedicineModel?,
            ),
          ),
        );
      case Routes.disableViewForWeCareMentalHealthUmbrella:
        return MaterialPageRoute(
            builder: (_) => DisableViewForWeCareMentalHealthUmbrella());
      case Routes.mentalIllnessAnsweredQuestionsView:
        return MaterialPageRoute(
          builder: (_) => MentalIllnessYesAnswersView(),
        );
      case Routes.chronicDiseaseDataView:
        return MaterialPageRoute(
          builder: (_) => ChronicDiseaseView(),
        );

      case Routes.chronicDiseaseDetailsView:
        final argumentsMap = arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => ChronicDiseaseDetailsView(
            documentId: argumentsMap['docId'] ?? "",
          ),
        );
      case Routes.chronicDiseaseDataEntry:
        final argumentsMap = arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => ChronicDiseaseDataEntryView(
            editModel: argumentsMap?['editModel'] as PostChronicDiseaseModel?,
            documentId: argumentsMap?['id'] as String?,
          ),
        );
      case Routes.userInfoNutrationDataEntry:
        return MaterialPageRoute(
          builder: (_) => UserNutrationInfoDataEntryView(),
        );
      case Routes.allergyDataEntry:
        final argumentsMap = arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => AllergyDataEntryView(
            existingAllergyModel:
                argumentsMap?['editModel'] as AllergyDetailsData?,
          ),
        );
      case Routes.followUpNutrationPlansView:
        return MaterialPageRoute(
          builder: (_) => FollowUpNutrationPlansView(),
        );
      case Routes.nutritionFollowUpReportTableView:
        return MaterialPageRoute(
          builder: (_) => NutritionFollowUpReportView(
            date: arguments as String,
          ),
        );
      case Routes.foodAlternativesView:
        return MaterialPageRoute(
          builder: (_) => FoodAlternativesView(
            elementName: arguments as String,
          ),
        );
      case Routes.foodRecomendationView:
        return MaterialPageRoute(
          builder: (_) => FoodRecomendationView(
            elementName: arguments as String,
          ),
        );
      case Routes.allergyDataView:
        return MaterialPageRoute(
          builder: (_) => AllergyDataView(),
        );
      case Routes.allergyDocDetailsView:
        final argumentsMap = arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => AllergyDetailsView(
            documentId: argumentsMap?['docId'] as String,
          ),
        );
      case Routes.nutritionPlanDataView:
        return MaterialPageRoute(
          builder: (_) => NutrationPlanDataView(),
        );
      default:
        return MaterialPageRoute(builder: (_) => NotFoundView());
    }
  }
}

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Found'),
      ),
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}
