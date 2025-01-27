import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/app_router.dart';
import 'package:we_care/generated/l10n.dart';

class WeCareApp extends StatelessWidget {
  const WeCareApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          title: 'We Care Mobile App',

          builder: (context, Widget? child) {
            return Directionality(
              textDirection: isArabic() ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          onGenerateRoute: appRouter.onGenerateRoutes,
          locale: const Locale(
            AppStrings.arabicLang,
          ), //TODO: handle localization cubit to switch between each locale later
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          // initialRoute: , ///checkAppFirstLogin() ? SignUpRoute : HomePageRoute
          theme: ThemeData(
            ///Later handle text field theme here to be same for all app
            //TODO: handle it later in seperate file
            scaffoldBackgroundColor: ColorsManager.scaffoldBackGroundColor,

            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
            ),
            useMaterial3: true,
          ),
          home: const DemoPage(),
        );
      },
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
    );
  }
}
