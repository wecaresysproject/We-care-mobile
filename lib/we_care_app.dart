import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/core/routing/routes.dart';

import 'core/global/Helpers/functions.dart';
import 'core/global/app_strings.dart';
import 'core/global/theming/color_manager.dart';
import 'core/routing/app_router.dart';
import 'generated/l10n.dart';

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
          initialRoute: isLoggedInUser ? Routes.bottomNavBar : Routes.loginView,
          theme: ThemeData(
            ///Later handle text field theme here to be same for all app
            //TODO: handle it later in seperate file
            scaffoldBackgroundColor: AppColorsManager.scaffoldBackGroundColor,
            fontFamily: AppStrings.cairoFontFamily,
            colorScheme: ColorScheme.fromSeed(
              primaryContainer: AppColorsManager.mainDarkBlue.withAlpha(25),
              seedColor: AppColorsManager.mainDarkBlue,
              outline:
                  AppColorsManager.textfieldOutsideBorderColor.withAlpha(120),
              tertiaryContainer: AppColorsManager.mainDarkBlue.withAlpha(25),
              surfaceContainerHighest: Colors.grey.shade100,
              surfaceContainerHigh: Colors.white,
              onTertiaryContainer: AppColorsManager.mainDarkBlue,
              // onSurfaceVariant: AppColorsManager.mainDarkBlue.withAlpha(25),
            ),

            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: kToolbarHeight - 30,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsManager.mainDarkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
            useMaterial3: true,
          ),
          // home: const CustomBottomNavBar(),
        );
      },
    );
  }
}
