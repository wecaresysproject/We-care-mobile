
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/x_ray_details_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_cubit.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_state.dart';

class XrayListBlocBuilder extends StatelessWidget {
  const XrayListBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<XRayViewCubit, XRayViewState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return Expanded(
              child: const Center(
                  child: CircularProgressIndicator(
            color: AppColorsManager.mainDarkBlue,
            backgroundColor: Colors.white,
          )));
        } else if (state.requestStatus==RequestStatus.failure){
             return Expanded(
            child: Center(
              child: Text( 'حدث خطأ في تحميل البيانات',
                  style: AppTextStyles.font22MainBlueWeight700),
            ),
          );
        } 
        else if (state.userRadiologyData.isEmpty &&
            state.requestStatus ==RequestStatus.success) {
          return Expanded(
            child: Center(
              child: Text('لا توجد نتائج',
                  style: AppTextStyles.font22MainBlueWeight700),
            ),
          );
        } else if (state.userRadiologyData.isNotEmpty &&
            state.requestStatus ==RequestStatus.success) {
          return MedicalItemGridView(
            items: state.userRadiologyData,
            onTap: (id) async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => XRayDetailsView(
                      documentId: id,
                    ),
                  ));
              if (context.mounted) {
                await context
                    .read<XRayViewCubit>()
                    .emitUserRadiologyData();
              }
            },
            titleBuilder: (item) => item.radioType,
            infoRowBuilder: (item) => [
              {"title": "التاريخ:", "value": item.radiologyDate},
              {"title": "منطقة الأشعة:", "value": item.bodyPart},
              {
                "title": "دواعي الفحص:",
                "value": item.symptoms ?? 'لم يتم ادخاله'
              },
              {"title": "ملاحظات:", "value": item.radiologyNote},
            ],
          );
        } else {
          return Container();
        }
      },
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