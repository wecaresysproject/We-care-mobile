import 'package:flutter/material.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/otp/Presentation/views/otp_view.dart';
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
      case Routes.otpView:
        return MaterialPageRoute(
          builder: (context) => const OtpView(),
        );

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
