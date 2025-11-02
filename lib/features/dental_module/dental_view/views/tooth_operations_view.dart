import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_cubit.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_state.dart';
import 'package:we_care/features/dental_module/dental_view/views/tooth_operation_details_view.dart';
import 'package:we_care/features/dental_module/dental_view/views/widgets/tooth_card_item_widget.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class ToothOperationsView extends StatelessWidget {
  const ToothOperationsView({super.key, required this.selectedTooth});
  final int selectedTooth;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<DentalViewCubit>()
        ..getDocumentsByToothNumber(toothNumber: selectedTooth.toString()),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              ViewAppBar(),
              verticalSpacing(16),
              BlocBuilder<DentalViewCubit, DentalViewState>(
                buildWhen: (previous, current) =>
                    previous.selectedToothList != current.selectedToothList,
                builder: (context, state) {
                  if (state.requestStatus == RequestStatus.loading) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state.requestStatus == RequestStatus.failure) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          state.message ?? "حدث خطأ",
                          style: AppTextStyles.font16DarkGreyWeight400,
                        ),
                      ),
                    );
                  } else if (state.selectedToothList == null ||
                      state.selectedToothList!.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          "لا توجد بيانات",
                          style: AppTextStyles.font22MainBlueWeight700,
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.selectedToothList!.length,
                      itemBuilder: (context, index) {
                        final doc = state.selectedToothList![index];
                        return ToothCardItemWidget(
                          item: doc,
                          onArrowTap: () async {
                            Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DentalOperationDetailsView(
                                    documentId: doc.id!,
                                    toothNumber: selectedTooth.toString(),
                                  ),
                                )).then(
                              (value) async {
                                if (!context.mounted) return;
                                await context
                                    .read<DentalViewCubit>()
                                    .getDocumentsByToothNumber(
                                        toothNumber: selectedTooth.toString());
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              verticalSpacing(16),
              ToothOperationsFooterRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class ToothOperationsFooterRow extends StatelessWidget {
  const ToothOperationsFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Load More Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                fixedSize: Size(158.w, 32.h),
                backgroundColor: AppColorsManager.mainDarkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "عرض المزيد",
                    style: AppTextStyles.font14whiteWeight600.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  horizontalSpacing(8.w),
                  Icon(
                    Icons.expand_more,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ],
              ),
            ),

            Container(
              width: 47.w,
              height: 28.h,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.r),
                border: Border.all(
                  color: Color(0xFF014C8A),
                  width: 2,
                ),
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
        ),
      ],
    );
  }
}

class DentalRecord {
  final String tooth;
  final DateTime date;
  final String procedure;
  final String painLevel;
  final String id;

  DentalRecord({
    required this.tooth,
    required this.date,
    required this.procedure,
    required this.painLevel,
    required this.id,
  });
}
