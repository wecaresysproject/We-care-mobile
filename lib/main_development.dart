import 'package:alarm/alarm.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/Services/push_notifications_services.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/bottom_nav_bar.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/core/routing/app_router.dart';
import 'package:we_care/features/chronic_disease/data/models/add_new_medicine_model.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/new_genetic_disease_model.dart';
import 'package:we_care/features/medicine/data/models/medicine_alarm_model.dart';
import 'package:we_care/features/medicine/medicines_api_constants.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/services/local_notifications_services.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/utils/logging.dart';
import 'package:we_care/firebase_options.dart';
import 'package:we_care/we_care_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");

  await LocalNotificationService.init();
  await PushNotificationsService.init(navigatorKey);
  tz.initializeTimeZones();

  await Hive.initFlutter();
  Hive.registerAdapter(MedicalComplaintAdapter());
  await Hive.openBox<MedicalComplaint>("medical_complaints");

  Hive.registerAdapter(AddNewMedicineModelAdapter());

  await Hive.openBox<AddNewMedicineModel>("addNewMedicine");

  Hive.registerAdapter(NewGeneticDiseaseModelAdapter());
  await Hive.openBox<NewGeneticDiseaseModel>("medical_genetic_diseases");

  Hive.registerAdapter(MedicineAlarmModelAdapter());
  await Hive.openBox<List<MedicineAlarmModel>>(
      MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);

  await setUpDependencyInjection();

  // To fix texts being hidden bug in flutter_screenutil in release mode.
  await ScreenUtil.ensureScreenSize();

  await checkIfLoggedInUser();

  //* The plugin redirects the user to auto-start permission screen to allow auto-start and fix background problems in some phones.
  // await getAutoStartPermission();

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

  setupLogging(showDebugLogs: true);

  await Alarm.init();

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

Future<void> checkAndroidScheduleExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.status;
  AppLogger.info('Schedule exact alarm permission: $status.');
  if (status.isDenied) {
    AppLogger.info('Requesting schedule exact alarm permission...');
    final res = await Permission.scheduleExactAlarm.request();
    AppLogger.info(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
  }
}
