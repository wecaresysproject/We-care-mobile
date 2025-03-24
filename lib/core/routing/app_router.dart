import 'package:flutter/material.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/Presentation/views/create_new_complaint_details_data_entry_view.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/Presentation/views/emergency_complaints_data_entry_view.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/views/emergency_complaints_view.dart';
import 'package:we_care/features/prescription/Presentation_view/views/prescription_details_view.dart';
import 'package:we_care/features/prescription/Presentation_view/views/prescription_view.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';
import 'package:we_care/features/prescription/prescription_data_entry/Presentation/views/prescription_data_entry_view.dart';
import 'package:we_care/features/show_data_entry_types/Presentation/views/medical_categories_types_view.dart';
import 'package:we_care/features/surgeries/surgeries_data_entry_view/Presentation/views/surgeries_data_entry_view.dart';
import 'package:we_care/features/surgeries/surgeries_view/views/surgeries_view.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/analysis_view.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/Presentation/views/test_analysis_data_entry_view.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/Presentation/views/vaccine_data_entry_view.dart';
import 'package:we_care/features/vaccine/vaccine_view/Presention/vaccine_view.dart';
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
        return MaterialPageRoute(
          builder: (context) => XrayCategoryDataEntryView(),
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
        return MaterialPageRoute(
          builder: (context) => const SurgeriesDataEntryView(),
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
        return MaterialPageRoute(
          builder: (context) => const EmergencyComplaintCategoryDataEntryView(),
        );
      case Routes.addNewComplaintDetails:
        final complaintDetails = arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => CreateNewComplaintDetailsView(
            editingComplaintDetails: complaintDetails?['complaint'],
            complaintId: complaintDetails?['id'],
          ),
        );

      case Routes.emergenciesComplaintDataView:
        return MaterialPageRoute(
          builder: (context) => const EmergencyComplaintsView(),
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
