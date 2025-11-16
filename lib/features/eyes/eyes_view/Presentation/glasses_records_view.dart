import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/glasses_details_view.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/widgets/glasses_records_item.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_cubit.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_state.dart';

class EyeGlassesRecordsView extends StatelessWidget {
  const EyeGlassesRecordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<EyeViewCubit>()..getEyeGlassesRecords(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0.h),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: BlocBuilder<EyeViewCubit, EyeViewState>(
            builder: (context, state) {
              final items = state.eyeGlassesRecords;

              return Column(
                children: [
                  AppBarWithCenteredTitle(
                    title: "بيانات النظارات",
                    showActionButtons: false,
                  ),
                  verticalSpacing(12),
                  if (state.requestStatus == RequestStatus.loading &&
                      items.isEmpty)
                    const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                  else if (items.isEmpty)
                    const Expanded(child: Center(child: Text("لا توجد بيانات")))
                  else
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final doc = items[index];
                          return GlassesRecordItem(
                            item: doc,
                            onArrowTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EyesGlassesDetailsView(
                                    documentId: doc.id,
                                  ),
                                ),
                              );
                              if (context.mounted) {
                                context
                                    .read<EyeViewCubit>()
                                    .getEyeGlassesRecords();
                              }
                            },
                          );
                        },
                      ),
                    ),
                  verticalSpacing(12),
                  if (state.isLoadingMore)
                    const Center(child: CircularProgressIndicator())
                  else if (state.isLoadingMore)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<EyeViewCubit>()
                                .loadMoreEyeGlassesRecords();
                          },
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
                              Text("عرض المزيد",
                                  style: AppTextStyles.font14whiteWeight600),
                              horizontalSpacing(8.w),
                              Icon(Icons.expand_more,
                                  color: Colors.white, size: 20.sp),
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
                              color: AppColorsManager.mainDarkBlue,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "+${items.length}",
                              style: AppTextStyles.font16DarkGreyWeight400
                                  .copyWith(
                                      color: AppColorsManager.mainDarkBlue),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

