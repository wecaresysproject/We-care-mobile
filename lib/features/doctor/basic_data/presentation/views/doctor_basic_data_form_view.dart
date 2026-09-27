import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/basic_data/logic/cubit/doctor_basic_data_cubit.dart';
import 'package:we_care/features/doctor/basic_data/presentation/views/widgets/doctor_basic_data_form_fields_widget.dart';
import 'package:we_care/features/doctor/shared/widgets/app_doctor_profile_header_widget.dart';

class DoctorBasicDataFormView extends StatelessWidget {
  const DoctorBasicDataFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DoctorBasicDataCubit>()..loadInitialData(),
      child: Scaffold(
        backgroundColor: AppColorsManager.scaffoldBackGroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppDoctorProfileHeaderWidget(
                  doctorName: 'د/ أحمد محمود',
                  specialty: 'استشاري جهاز مناعي',
                  doctorPhotoUrl: 'assets/images/doctor_photo.png',
                  isOnline: true,
                ),
                verticalSpacing(20),
                const DoctorBasicDataFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
