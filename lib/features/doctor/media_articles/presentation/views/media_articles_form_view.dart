import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/media_articles/logic/cubit/media_articles_cubit.dart';
import 'package:we_care/features/doctor/media_articles/presentation/views/widgets/media_articles_form_fields_widget.dart';
import 'package:we_care/features/doctor/shared/widgets/app_doctor_profile_header_widget.dart';

class MediaArticlesFormView extends StatelessWidget {
  const MediaArticlesFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MediaArticlesCubit>(),
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
                const MediaArticlesFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
