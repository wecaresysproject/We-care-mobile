import 'package:flutter/material.dart';
import 'package:we_care/core/global/SharedWidgets/bottom_nav_bar.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/create_new_password/Presentation/views/create_new_password_view.dart';
import 'package:we_care/features/forget_password/Presentation/views/forget_password_view.dart';
import 'package:we_care/features/home_tab/Presentation/views/view_or_edit_medical_record_view.dart';
import 'package:we_care/features/login/Presentation/views/login_view.dart';
import 'package:we_care/features/otp/Presentation/views/otp_view.dart';
import 'package:we_care/features/show_data_entry_types/Presentation/views/data_entry_types_view.dart';
import 'package:we_care/features/sign_up/Presentation/views/sign_up_view.dart';
import 'package:we_care/features/user_type/Presentation/views/user_type_view.dart';

class AppRouter {
//automatically recalled when we use Navigator in our screen
  Route<dynamic>? onGenerateRoutes(RouteSettings route) {
    String routeName = route.name!;
    // ignore: unused_local_variable
    final arguments = route.arguments as Map<String,
        dynamic>?; //!recheck as later , as it can be dynamic for most cases

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
          ),
        );
      case Routes.createNewPasswordView:
        return MaterialPageRoute(
          builder: (context) => CreateNewPasswordView(),
        );
      case Routes.bottomNavBar:
        return MaterialPageRoute(
          builder: (context) => const CustomBottomNavBar(),
        );
      case Routes.viewOrEditMedicalRecord:
        return MaterialPageRoute(
          builder: (context) => const ViewOrEditMedicalRecord(),
        );
      case Routes.dateEntryTypesView:
        return MaterialPageRoute(
          builder: (context) => DataEntryCategoryTypesView(),
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
