import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/networking/auth_service.dart';
import 'package:we_care/core/networking/dio_serices.dart';
import 'package:we_care/features/create_new_password/Presentation/view_models/cubit/create_new_password_cubit.dart';
import 'package:we_care/features/forget_password/Presentation/view_models/cubit/forget_password_cubit.dart';
import 'package:we_care/features/login/Presentation/view_models/cubit/cubit/login_cubit.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';
import 'package:we_care/features/sign_up/Data/repos/sign_up_repo.dart';

import '../../features/sign_up/logic/sign_up_cubit.dart';

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
    () => LoginCubit(),
  );
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(),
  );
  getIt.registerFactory<CreateNewPasswordCubit>(
    () => CreateNewPasswordCubit(),
  );
  getIt.registerFactory<XRayDataEntryCubit>(
    () => XRayDataEntryCubit(),
  );
}

void setupAppRepos() {
  getIt.registerLazySingleton<SignUpRepo>(
    () => SignUpRepo(
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
