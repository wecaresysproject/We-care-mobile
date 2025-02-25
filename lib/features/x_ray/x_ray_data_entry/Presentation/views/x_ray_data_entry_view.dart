import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/x_ray/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';

import 'widgets/x_ray_data_form_fields_widget.dart';

class XrayCategoryDataEntryView extends StatelessWidget {
  const XrayCategoryDataEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<XRayDataEntryCubit>(
      create: (context) => getIt<XRayDataEntryCubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBarWidget(
                  haveBackArrow: true,
                ),
                verticalSpacing(24),
                XRayDataEntryFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
