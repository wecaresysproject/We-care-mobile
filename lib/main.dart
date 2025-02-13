import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/routing/app_router.dart';
import 'package:we_care/features/forget_password/Presentation/view_models/cubit/forget_password_cubit.dart';
import 'package:we_care/features/sign_up/logic/sign_up_cubit.dart';
import 'package:we_care/we_care_app.dart';

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
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiBlocProvider(
        //!TODO: remove MultiBlocProvider later from main
        providers: [
          BlocProvider<SignUpCubit>(
            create: (_) => getIt<SignUpCubit>(),
          ),
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
