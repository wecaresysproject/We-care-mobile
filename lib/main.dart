import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/core/routing/app_router.dart';
import 'package:we_care/we_care_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDependencyInjection();
  // To fix texts being hidden bug in flutter_screenutil in release mode.
  await ScreenUtil.ensureScreenSize();
  await checkIfLoggedInUser();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Light status bar
      // statusBarIconBrightness: Brightness.dark, // Dark icons for status bar
      systemNavigationBarColor: Colors.white, // Light navigation bar
      // systemNavigationBarIconBrightness:
      //     Brightness.dark, // Dark icons for navigation bar
    ),
  );
  // Lock the app to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (_) {
      runApp(
        DevicePreview(
          enabled: false,
          builder: (context) => WeCareApp(
            appRouter: AppRouter(),
          ),
        ),
      );
    },
  );
}

Future<void> checkIfLoggedInUser() async {
  String? userToken =
      await CacheHelper.getSecuredString(AuthApiConstants.userTokenKey);
  if (!userToken.isEmptyOrNull) {
    isLoggedInUser = false;
  } else {
    isLoggedInUser = true;
  }
}
