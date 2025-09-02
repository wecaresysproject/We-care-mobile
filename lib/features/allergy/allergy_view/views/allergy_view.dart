// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:we_care/core/di/dependency_injection.dart';
// import 'package:we_care/core/global/Helpers/app_enums.dart';
// import 'package:we_care/core/global/Helpers/extensions.dart';
// import 'package:we_care/core/global/Helpers/functions.dart';
// import 'package:we_care/core/global/theming/app_text_styles.dart';
// import 'package:we_care/core/global/theming/color_manager.dart';
// import 'package:we_care/core/routing/routes.dart';
// import 'package:we_care/features/allergy/allergy_view/logic/allergy_view_cubit.dart';
// import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';
// import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

// class AllergyDataView extends StatelessWidget {
//   const AllergyDataView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<AllergyViewCubit>(
//       create: (context) => getIt<AllergyViewCubit>()..getUserSurgeriesList(),
//       child: Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 0.h,
//         ),
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//           child: Column(
//             children: [
//               ViewAppBar(),
//               verticalSpacing(16),
//               BlocBuilder<AllergyViewCubit, AllergyViewState>(
//                 buildWhen: (previous, current) =>
//                     previous.userSurgeries != current.userSurgeries,
//                 builder: (context, state) {
//                   if (state.requestStatus == RequestStatus.loading) {
//                     return Expanded(
//                         child:
//                             const Center(child: CircularProgressIndicator()));
//                   } else if (state.userSurgeries.isEmpty &&
//                       state.requestStatus == RequestStatus.success) {
//                     return Expanded(
//                       child: Center(
//                           child: Text(
//                         "لا يوجد بيانات",
//                         style: AppTextStyles.font22MainBlueWeight700,
//                       )),
//                     );
//                   }
//                   return MedicalItemGridView(
//                     items: state.userSurgeries,
//                     onTap: (id) async {
//                       await context.pushNamed(
//                         Routes.allergyDocDetailsView,
//                         arguments: {
//                           'docId': id,
//                         },
//                       );
//                       if (context.mounted) {
//                         await context
//                             .read<AllergyViewCubit>()
//                             .getUserSurgeriesList();
//                         await context
//                             .read<AllergyViewCubit>()
//                             .getSurgeriesFilters();
//                       }
//                     },
//                     titleBuilder: (item) => item.surgeryName,
//                     infoRowBuilder: (item) => [
//                       {"title": "التاريخ:", "value": item.surgeryDate},
//                       {"title": "منطقة العملية:", "value": item.surgeryRegion},
//                       {"title": "حالة العملية:", "value": item.surgeryStatus},
//                       {"title": "ملاحظات:", "value": item.additionalNotes},
//                     ],
//                   );
//                 },
//               ),
//               verticalSpacing(16),
//               AllergyFooterRow(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allergy/allergy_view/logic/allergy_view_cubit.dart';
import 'package:we_care/features/allergy/allergy_view/views/widgets/allergy_horizental_card_widget.dart';
import 'package:we_care/features/allergy/data/models/allergy_disease_model.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class AllergyFooterRow extends StatelessWidget {
  const AllergyFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllergyViewCubit, AllergyViewState>(
      builder: (context, state) {
        final cubit = context.read<AllergyViewCubit>();
        return Column(
          children: [
            // Loading indicator that appears above the footer when loading more items
            if (state.isLoadingMore)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: LinearProgressIndicator(
                  minHeight: 2.h,
                  color: AppColorsManager.mainDarkBlue,
                  backgroundColor:
                      AppColorsManager.mainDarkBlue.withOpacity(0.1),
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Load More Button
                ElevatedButton(
                  onPressed: state.isLoadingMore || !cubit.hasMore
                      ? null
                      : () => cubit.loadMoreMedicines(),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(158.w, 32.h),
                    backgroundColor: state.isLoadingMore || !cubit.hasMore
                        ? Colors.grey
                        : AppColorsManager.mainDarkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: state.isLoadingMore
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            horizontalSpacing(8.w),
                            Text(
                              "جاري التحميل...",
                              style: AppTextStyles.font14whiteWeight600,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "عرض المزيد",
                              style:
                                  AppTextStyles.font14whiteWeight600.copyWith(
                                color: !cubit.hasMore
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            horizontalSpacing(8.w),
                            Icon(
                              Icons.expand_more,
                              color:
                                  !cubit.hasMore ? Colors.black : Colors.white,
                              size: 20.sp,
                            ),
                          ],
                        ),
                ),

                // Items Count Badge
                !cubit.hasMore
                    ? SizedBox.shrink()
                    : Container(
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
                            "+${cubit.pageSize}",
                            style:
                                AppTextStyles.font16DarkGreyWeight400.copyWith(
                              color: AppColorsManager.mainDarkBlue,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class AllergyDataView extends StatelessWidget {
  AllergyDataView({super.key});

  List<AllergyDiseaseModel> dummyList = [
    AllergyDiseaseModel(
      causes: [
        'غبار, حبوب لقاح',
      ],
      date: '2022-01-15',
      severity: 'شديدة',
      title: 'حساسية الحليب',
      precautions: 'تجنب الخروج في أوقات الذروة',
      id: '1',
    ),
    AllergyDiseaseModel(
      causes: [
        'مكسرات, شوكولاتة',
      ],
      date: '2021-11-10',
      severity: 'متوسطة',
      title: 'حساسية المكسرات',
      precautions: 'قراءة مكونات الطعام بعناية',
      id: '2',
    ),
    AllergyDiseaseModel(
      causes: [
        'غبار, حبوب لقاح',
      ],
      date: '2022-01-15',
      severity: 'شديدة',
      title: 'حساسية الربيع',
      precautions: 'تجنب الخروج في أوقات الذروة',
      id: '3',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AllergyViewCubit>(
      create: (context) => getIt<AllergyViewCubit>()..getUserSurgeriesList(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0.h),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              ViewAppBar(),
              verticalSpacing(16),
              Expanded(
                child: BlocBuilder<AllergyViewCubit, AllergyViewState>(
                  buildWhen: (previous, current) =>
                      previous.userSurgeries != current.userSurgeries,
                  builder: (context, state) {
                    // if (state.requestStatus == RequestStatus.loading) {
                    //   return const Center(child: CircularProgressIndicator());
                    // } else if (state.userSurgeries.isEmpty &&
                    //     state.requestStatus == RequestStatus.success) {
                    //   return Center(
                    //     child: Text(
                    //       "لا يوجد بيانات",
                    //       style: AppTextStyles.font22MainBlueWeight700,
                    //     ),
                    //   );
                    // }

                    return ListView.separated(
                      itemCount:
                          dummyList.length, // state.userSurgeries.length,
                      separatorBuilder: (_, __) => verticalSpacing(12),
                      itemBuilder: (context, index) {
                        // final item = state.userSurgeries[index];
                        final item = dummyList[index];
                        return AllergyHorizentalCardWidget(
                          item: item,
                          onArrowTap: () async {
                            await context.pushNamed(
                              Routes.allergyDocDetailsView,
                              arguments: {'docId': item.id},
                            );
                            if (context.mounted) {
                              await context
                                  .read<AllergyViewCubit>()
                                  .getUserSurgeriesList();
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              verticalSpacing(16),
              AllergyFooterRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class AllergyCard extends StatelessWidget {
  final String title;
  final String date;
  final String causes;
  final String severity;
  final String precautions;
  final VoidCallback onTap;

  const AllergyCard({
    super.key,
    required this.title,
    required this.date,
    required this.causes,
    required this.severity,
    required this.precautions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      title,
                      style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColorsManager.mainDarkBlue,
                      ),
                    ),
                  ),
                  verticalSpacing(6),
                  _buildInfoRow("التاريخ:", date),
                  _buildInfoRow("المسببات:", causes),
                  _buildInfoRow("حدة الأعراض:", severity),
                  _buildInfoRow("الاحتياطات:", precautions, isMultiLine: true),
                ],
              ),
            ),

            horizontalSpacing(8.w),

            // Arrow icon
            Icon(
              Icons.arrow_back_ios,
              color: AppColorsManager.mainDarkBlue,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title ",
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: value,
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: Colors.black,
              ),
            ),
          ],
        ),
        maxLines: isMultiLine ? 3 : 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
