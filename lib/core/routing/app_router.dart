import 'package:flutter/material.dart';

class AppRouter {
//automatically recalled when we use Navigator in our screen
  Route<dynamic>? onGenerateRoutes(RouteSettings route) {
    String routeName = route.name!;
    final arguments = route.arguments;

    //! provide the nedded bloc providers here

    switch (routeName) {
      // case splashscreen:
      //   return MaterialPageRoute(builder: (context) => const SplashView());

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
