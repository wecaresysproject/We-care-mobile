import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/networking/app_interceptors.dart';
import 'package:we_care/core/networking/dio_web_services.dart';
import 'package:we_care/features/sign_up/Presentation/view_models/cubit/sign_up_cubit.dart';

final getIt = GetIt.instance;
Future<void> setUpDependencyInjection() async {
  // the object of this class called only when we trigger this object in our app
  // not when this function called setUpDependencyInjection() called before running the app
  //and dont be intialliazed another object any more again too
  getIt.registerLazySingleton<DioInterceptor>(
    () => DioInterceptor(),
  );
  getIt.registerLazySingleton<LogInterceptor>(
    () => LogInterceptor(
      responseBody: true,
      error: true,
      requestHeader: false,
      responseHeader: false,
      request: true,
      requestBody: true,
    ),
  );
  // getIt.registerSingleton<HiveServices>(
  //   await HiveServices.create(),
  // ); //! recheck this later
  getIt.registerLazySingleton<CacheHelper>(
    () => CacheHelper(),
  );

  // getIt.registerLazySingleton<LocalizationCubit>(
  //   () => LocalizationCubit(),
  // );

  getIt.registerLazySingleton<Dio>(
    () => Dio(),
  );
  getIt.registerLazySingleton<DioWebServices>(
    () => DioWebServices(
      dio: getIt<Dio>(),
    ),
  );
  // signup
  // getIt.registerLazySingleton<SignupRepo>(() => SignupRepo(getIt()));
  getIt.registerFactory<SignUpCubit>(() => SignUpCubit());
}
