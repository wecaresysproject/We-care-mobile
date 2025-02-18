import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/Database/cach_helper.dart';
import 'core/di/dependency_injection.dart';
import 'core/global/Helpers/extensions.dart';
import 'core/networking/auth_api_constants.dart';
import 'core/routing/app_router.dart';
import 'features/forget_password/Presentation/view_models/cubit/forget_password_cubit.dart';
import 'we_care_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDependencyInjection();
  // To fix texts being hidden bug in flutter_screenutil in release mode.
  await ScreenUtil.ensureScreenSize();
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Light status bar
      // statusBarIconBrightness: Brightness.dark, // Dark icons for status bar
      systemNavigationBarColor: Colors.white, // Light navigation bar
      // systemNavigationBarIconBrightness:
      //     Brightness.dark, // Dark icons for navigation bar
    ),
  );
  await checkIfLoggedInUser();
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiBlocProvider(
        //!TODO: remove MultiBlocProvider later from main
        providers: [
          BlocProvider<ForgetPasswordCubit>(
            create: (_) => getIt<ForgetPasswordCubit>(),
          ),
        ],
        child: WeCareApp(
          appRouter: AppRouter(),
        ),
      ),
    ),
  );
}

//! set isLoggedInUser to be false when user logs out
Future<void> checkIfLoggedInUser() async {
  String? userToken =
      await CacheHelper.getSecuredString(AuthApiConstants.userTokenKey);
  if (!userToken.isEmptyOrNull) {
    isLoggedInUser = true;
  } else {
    isLoggedInUser = false;
  }
}
