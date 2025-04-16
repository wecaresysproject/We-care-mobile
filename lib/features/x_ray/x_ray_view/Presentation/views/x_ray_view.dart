import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/xray_filters_bloc_builder.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/xray_list_bloc_builder.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_cubit.dart';


class XRayView extends StatelessWidget {
  const XRayView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<XRayViewCubit>(
      create: (context) => getIt<XRayViewCubit>()..init(),
      child: RefreshIndicator(
        onRefresh: () => BlocProvider.of<XRayViewCubit>(context).init(),
        color: AppColorsManager.mainDarkBlue,
        backgroundColor: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0.h,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              spacing: 16.h,
              children: [
                ViewAppBar(),
                XrayFiltersBlocBuilder(),
                XrayListBlocBuilder(),
                XRayDataViewFooterRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
