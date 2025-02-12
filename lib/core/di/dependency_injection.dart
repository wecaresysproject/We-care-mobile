import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_care/core/networking/dio_serices.dart';
import 'package:we_care/features/create_new_password/Presentation/view_models/cubit/create_new_password_cubit.dart';
import 'package:we_care/features/forget_password/Presentation/view_models/cubit/forget_password_cubit.dart';
import 'package:we_care/features/login/Presentation/view_models/cubit/cubit/login_cubit.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';
import 'package:we_care/features/sign_up/logic/sign_up_cubit.dart';

final getIt = GetIt.instance;
Future<void> setUpDependencyInjection() async {
  // the object of this class called only when we trigger this object in our app
  // not when this function called setUpDependencyInjection() called before running the app
  //and dont be intialliazed another object any more again too

  // getIt.registerSingleton<HiveServices>(
  //   await HiveServices.create(),
  // ); //! recheck this later

  // ignore: unused_local_variable
  Dio dio = DioServices.getDio();

  // signup
  // getIt.registerLazySingleton<SignupRepo>(() => SignupRepo(getIt()));
  getIt.registerFactory<SignUpCubit>(
    () => SignUpCubit(),
  );
  // login
  // getIt.registerLazySingleton<loginRepo>(() => loginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(),
  );
  // login
  // getIt.registerLazySingleton<ResetPasswordRepo>(() => ResetPasswordRepo(getIt()));
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(),
  );

  //create new password
  // getIt.registerLazySingleton<CreateNewPasswordRepo>(() => CreateNewPasswordRepo(getIt()));
  getIt.registerFactory<CreateNewPasswordCubit>(
    () => CreateNewPasswordCubit(),
  );

  //create XRayDataEntryCubit
  getIt.registerFactory<XRayDataEntryCubit>(
    () => XRayDataEntryCubit(),
  );
  //create XRayDataEntryCubit
  getIt.registerLazySingleton<ImagePicker>(
    () => ImagePicker(),
  );
}
