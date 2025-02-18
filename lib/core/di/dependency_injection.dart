import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/create_new_password/Presentation/view_models/cubit/create_new_password_cubit.dart';
import '../../features/forget_password/Data/Repostory/forget_password_repo.dart';
import '../../features/create_new_password/Data/repo/create_new_password_repo.dart';
import '../../features/forget_password/Presentation/view_models/cubit/forget_password_cubit.dart';
import '../../features/login/Data/Repostory/login_repo.dart';
import '../../features/login/logic/cubit/login_cubit.dart';
import '../../features/otp/Data/repo/otp_repository.dart';
import '../../features/otp/logic/otp_cubit.dart';
import '../../features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';
import '../../features/sign_up/Data/repos/sign_up_repo.dart';
import '../../features/sign_up/logic/sign_up_cubit.dart';
import '../global/Helpers/image_quality_detector.dart';
import '../networking/auth_service.dart';
import '../networking/dio_serices.dart';

final getIt = GetIt.instance;
Future<void> setUpDependencyInjection() async {
  // getIt.registerSingleton<HiveServices>(
  //   await HiveServices.create(),
  // ); //! recheck this later

  setupAppServices();
  setupAppRepos();
  setupAppCubits();
}

void setupAppCubits() {
  getIt.registerFactory<SignUpCubit>(
    () => SignUpCubit(
      getIt<SignUpRepo>(),
    ),
  );
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      getIt<LoginRepo>(),
    ),
  );
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(
      getIt<ForgetPasswordRepo>(),
    ),
  );
  getIt.registerFactory<CreateNewPasswordCubit>(
    () => CreateNewPasswordCubit(
      getIt<CreateNewPasswordRepo>(),
    ),
  );
  getIt.registerFactory<XRayDataEntryCubit>(
    () => XRayDataEntryCubit(),
  );

  getIt.registerFactory<OtpCubit>(
    () => OtpCubit(
      getIt<OtpRepository>(),
    ),
  );
}

void setupAppRepos() {
  getIt.registerLazySingleton<SignUpRepo>(
    () => SignUpRepo(
      getIt<AuthApiServices>(),
    ),
  );

  getIt.registerLazySingleton<OtpRepository>(
    () => OtpRepository(
      getIt<AuthApiServices>(),
    ),
  );
  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepo(
      getIt<AuthApiServices>(),
    ),
  );
  getIt.registerLazySingleton<ForgetPasswordRepo>(
    () => ForgetPasswordRepo(
      getIt<AuthApiServices>(),
    ),
  );

  getIt.registerLazySingleton<CreateNewPasswordRepo>(
    () => CreateNewPasswordRepo(
      getIt<AuthApiServices>(),
    ),
  );
}

void setupAppServices() {
  Dio dio = DioServices.getDio();
  getIt.registerLazySingleton<AuthApiServices>(() => AuthApiServices(dio));
  getIt.registerLazySingleton<ImagePicker>(
    () => ImagePicker(),
  );

  getIt.registerLazySingleton<ImagePickerService>(
    () => ImagePickerService(),
  );
}
