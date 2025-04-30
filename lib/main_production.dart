import 'package:alarm/alarm.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/core/routing/app_router.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/medicine/data/models/medicine_alarm_model.dart';
import 'package:we_care/features/medicine/medicines_api_constants.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/services/notifications.dart';
import 'package:we_care/we_care_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await Hive.initFlutter();
  Hive.registerAdapter(MedicalComplaintAdapter());
  await Hive.openBox<MedicalComplaint>("medical_complaints");
  Hive.registerAdapter(MedicineAlarmModelAdapter());
  await Hive.openBox<MedicineAlarmModel>(
    MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey,
  );

  await setUpDependencyInjection();

  // To fix texts being hidden bug in flutter_screenutil in release mode.
  await ScreenUtil.ensureScreenSize();

  await checkIfLoggedInUser();

  await Notifications.init();

  await Alarm.init();

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
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => WeCareApp(
        appRouter: AppRouter(),
      ),
    ),
  );
}

//* Check if this is the first app launch after install.
//* SharedPreferences is cleared on uninstall, but secure storage is not.
//* So if the key is missing, we treat it as a fresh install and clear secure data.
Future<void> checkIfLoggedInUser() async {
  final isFirstRun = await CacheHelper.getBool(AppStrings.hasRunBefore);

  if (!isFirstRun) {
    // First app launch after install – clear secure storage
    await CacheHelper.clearAllSecuredData();
    await CacheHelper.setData(AppStrings.hasRunBefore, true);
  }

  String? userToken =
      await CacheHelper.getSecuredString(AuthApiConstants.userTokenKey);
  if (userToken.isEmptyOrNull) {
    isLoggedInUser = false;
  } else {
    isLoggedInUser = true;
  }
}
