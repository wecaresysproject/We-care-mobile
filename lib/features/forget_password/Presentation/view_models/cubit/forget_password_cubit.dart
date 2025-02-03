import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ResetPasswordInitial());
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> emitResetPasswordState() async {}
}
