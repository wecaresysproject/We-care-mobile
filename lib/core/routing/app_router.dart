import 'package:flutter/material.dart';
import 'package:we_care/core/global/SharedWidgets/bottom_nav_bar.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/forget_password/Presentation/views/forget_password_view.dart';
import 'package:we_care/features/login/Presentation/views/login_view.dart';
import 'package:we_care/features/otp/Presentation/views/otp_view.dart';
import 'package:we_care/features/show_data_entry_types/Presentation/views/show_data_entry_categories_view.dart';
import 'package:we_care/features/sign_up/Presentation/views/sign_up_view.dart';
import 'package:we_care/features/user_type/Presentation/views/user_type_view.dart';

class AppRouter {
//automatically recalled when we use Navigator in our screen
  Route<dynamic>? onGenerateRoutes(RouteSettings route) {
    String routeName = route.name!;
    // ignore: unused_local_variable
    final arguments = route.arguments;

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
        return MaterialPageRoute(
          builder: (context) => const OtpView(),
        );
      case Routes.bottomNavBar:
        return MaterialPageRoute(
          builder: (context) => const CustomBottomNavBar(),
        );
      case Routes.dateEntryTypesView:
        return MaterialPageRoute(
          builder: (context) => const DataEntryCategoryTypesView(),
        );
      // case Routes.homeTabView:
      //   return MaterialPageRoute(
      //     builder: (context) => const HomeTabView(),
      //   );

      // case bottomNavBar:
      //   return MaterialPageRoute(
      //     builder: (context) => CustomBottomNavBar(),
      //   );

      // case homeTabView:
      //   return MaterialPageRoute(builder: (context) => const HomeTabView());
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
