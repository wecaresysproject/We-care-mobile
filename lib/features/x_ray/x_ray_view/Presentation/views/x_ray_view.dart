import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_cubit.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_state.dart';

import 'widgets/x_ray_data_filters_row.dart';
import 'widgets/x_ray_data_grid_view.dart';
import 'x_ray_details_view.dart';

class XRayView extends StatelessWidget {
  const XRayView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<XRayViewCubit>(
      create: (context) => getIt<XRayViewCubit>()..emitUserRadiologyData(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              ViewAppBar(),
              DataViewFiltersRow(
                filters: [
                  FilterConfig(
                      title: 'السنة',
                      options: List.generate(
                          20, (index) => (2010 + index).toString()),
                      isYearFilter: true),
                  FilterConfig(
                      title: 'نوع المنظار',
                      options: ['الكل', 'المنظار العادي', 'المنظار الرقمي']),
                  FilterConfig(
                      title: 'نوع الاجراء',
                      options: ['الكل', 'الاشعة', 'التحاليل', 'المنظار']),
                ],
                onApply: () {
                  // Handle apply button action
                },
              ),
              verticalSpacing(16),
              BlocBuilder<XRayViewCubit, XRayViewState>(
                builder: (context, state) {
                  if (state.requestStatus == RequestStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.requestStatus == RequestStatus.success) {
                    return MedicalItemGridView(
                      items: state.userRadiologyData,
                      onTap: (id) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => XRayDetailsView(
                              documentId: id,
                            ),
                          )),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              verticalSpacing(16),
              XRayDataViewFooterRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class XRayDataViewFooterRow extends StatelessWidget {
  const XRayDataViewFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(158, 32),
            backgroundColor: AppColorsManager.mainDarkBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.zero, // No default padding
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "عرض المزيد",
                style: AppTextStyles.font14whiteWeight600,
              ),
              horizontalSpacing(8),
              Icon(
                Icons.expand_more,
                color: Colors.white,
                weight: 100,
                size: 24.sp,
              ),
            ],
          ),
        ),
        Container(
          width: 47.w,
          height: 28.h,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11.r),
            border: Border.all(color: Color(0xFF014C8A), width: 2),
          ),
          child: Center(
            child: Text(
              "+10",
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
