import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.intialState());

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void emitLoginStates() async {
    try {
      emit(state.copyWith(loginStatus: RequestStatus.loading));

      // Simulating API request delay
      await Future.delayed(Duration(seconds: 2));

      // Example condition (Replace with API logic)
      if (phoneController.text.contains("010")) {
        emit(state.copyWith(loginStatus: RequestStatus.success));
      } else {
        emit(state.copyWith(
            loginStatus: RequestStatus.failure,
            errorMessage: 'Invalid phone number'));
      }
    } catch (e) {
      emit(
        state.copyWith(
          loginStatus: RequestStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
